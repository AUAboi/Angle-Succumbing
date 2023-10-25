extends Sprite2D

#Change spell here
@export var spell_scene: PackedScene = preload("res://Weapons/stone_canon/stone_canon.tscn")

@onready var muzzle: Marker2D = $Muzzle
@onready var cooldown_timer: Timer = $Timer
@onready var charge_timer: Timer = $ChargeTimer
@onready var bar: Control = $ReloadBar

var progress: float = 0.00
var is_on_cooldown: bool = false
var cooldown : float
var bar_speed: float 

var spell: Spell

var spell_type: SpellStats.SpellTypes

enum StaffStates { IDLE, CHARGING }

var staff_state: StaffStates = StaffStates.IDLE

func _ready() -> void:
	var spell_instance: Spell = spell_scene.instantiate() as Spell
	spell_type = spell_instance.spell_stats.type
	cooldown = spell_instance.spell_stats.cooldown
	
	spell_instance.queue_free()

func _process(_delta: float) -> void:
	bar.set_value(progress)
	if is_on_cooldown:
		progress = cooldown_timer.time_left * bar_speed

func _physics_process(_delta: float) -> void:
	if !is_on_cooldown:
		match spell_type:
			SpellStats.SpellTypes.NORMAL:
				handle_normal()
			SpellStats.SpellTypes.CHARGEABLE:
				handle_charged()

func handle_normal() -> void:
	if Input.is_action_pressed("shoot"):
		spell = spell_scene.instantiate() as Spell
		get_tree().root.add_child(spell)
		spell.transform = muzzle.global_transform
		
		start_cooldown()

func handle_charged() -> void: 
	if Input.is_action_pressed("shoot"):
		if staff_state == StaffStates.IDLE:
				staff_state = StaffStates.CHARGING
				spell = spell_scene.instantiate() as Spell
				get_tree().root.add_child(spell)
				spell.position = muzzle.global_position
				spell.rotation = muzzle.global_rotation
				spell.spell_state = Spell.SpellStates.CHARGING
				
		elif staff_state == StaffStates.CHARGING:
			if not is_instance_valid(spell):
				start_cooldown()
			else:
				spell.position = muzzle.global_position
				spell.rotation = muzzle.global_rotation
	
	elif Input.is_action_just_released("shoot"):
		start_cooldown()
		if spell == null:
			staff_state = StaffStates.IDLE
		else:
			if staff_state == StaffStates.CHARGING:
				spell.cast()

func start_cooldown() -> void:
	is_on_cooldown = true
	bar_speed = 100 / cooldown
	cooldown_timer.start(cooldown)

func _on_timer_timeout() -> void:
	progress = 0
	is_on_cooldown = false
	staff_state = StaffStates.IDLE
