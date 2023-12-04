extends Sprite2D

#Change spell here
@export var spell_scene: PackedScene = preload("res://Weapons/stone_canon/stone_canon.tscn")

@onready var muzzle: Marker2D = $Muzzle
@onready var cooldown_timer: Timer = $Timer
@onready var charge_timer: Timer = $ChargeTimer
@onready var bar: Control = $ReloadBar

var _is_on_cooldown: bool = false
var _cooldown : float
var _progress: float = 0.00
var _bar_speed: float 

var spell: Spell

var spell_type: SpellStats.SpellTypes

enum StaffStates { IDLE, CHARGING }

var staff_state: StaffStates = StaffStates.IDLE

func _ready() -> void:
	var spell_instance: Spell = spell_scene.instantiate() as Spell
	spell_type = spell_instance.spell_stats.type
	_cooldown = spell_instance.spell_stats.cooldown
	
	spell_instance.queue_free()

func _process(_delta: float) -> void:
	bar.set_value(_progress)
	if _is_on_cooldown:
		_progress = cooldown_timer.time_left * _bar_speed

func _physics_process(_delta: float) -> void:
	if !_is_on_cooldown:
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
		match staff_state:
			StaffStates.IDLE:
				staff_state = StaffStates.CHARGING
				spell = spell_scene.instantiate() as Spell
				get_tree().root.add_child(spell)
				spell.position = muzzle.global_position
				spell.rotation = muzzle.global_rotation
				spell.spell_state = Spell.SpellStates.CHARGING
				
			StaffStates.CHARGING:
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
	_is_on_cooldown = true
	_bar_speed = 100 / _cooldown
	cooldown_timer.start(_cooldown)

func _on_timer_timeout() -> void:
	_progress = 0
	_is_on_cooldown = false
	staff_state = StaffStates.IDLE
