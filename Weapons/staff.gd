extends Sprite2D

#Change spell here
@export var spell_scene: PackedScene = preload("res://Weapons/ice_shard/ice_shard.tscn")

@onready var muzzle: Marker2D = $Muzzle
@onready var cooldown_timer: Timer = $Timer
@onready var charge_timer: Timer = $ChargeTimer
@onready var bar: Control = $ReloadBar

var progress: float = 0.00
var is_on_cooldown: bool = false
var cooldown : float
var bar_speed: float 

var charge_held_time: float = 0

var spell: Spell

var spell_type: Spell.SPELL_TYPE

enum STAFF_STATES { IDLE, CHARGING, SHOT }

var state: STAFF_STATES = STAFF_STATES.IDLE

func _ready() -> void:
	spell_type = spell_scene.instantiate().type

func _process(_delta: float) -> void:
	bar.set_value(progress)
	if is_on_cooldown:
		progress = cooldown_timer.time_left * bar_speed

func _physics_process(delta: float) -> void:
	if !is_on_cooldown:
		match spell_type:
			Spell.SPELL_TYPE.NORMAL:
				if Input.is_action_pressed("shoot"):
					shoot(delta)
					
			Spell.SPELL_TYPE.CHARGEABLE:
				if Input.is_action_pressed("shoot"):
					charge_held_time += delta
					if state == STAFF_STATES.IDLE:
							spell = spell_scene.instantiate() as Spell
							state = STAFF_STATES.CHARGING
							
							get_tree().root.add_child(spell)
							spell.transform = muzzle.global_transform
					
					
				elif Input.is_action_just_released("shoot"):
					if(spell == null):
						state = STAFF_STATES.IDLE
					else:
						if state == STAFF_STATES.CHARGING:
							spell.cast(charge_held_time)
							state = STAFF_STATES.SHOT
							is_on_cooldown = true
							cooldown = spell.cooldown
							bar_speed = 100 / cooldown
							cooldown_timer.start(cooldown)
					
					charge_held_time = 0
					
func shoot(delta: float) -> void: 
	if !is_on_cooldown:
		match spell_type:
			Spell.SPELL_TYPE.NORMAL:
				spell = spell_scene.instantiate() as Spell
				
				get_tree().root.add_child(spell)
				spell.transform = muzzle.global_transform
				
				is_on_cooldown = true
				cooldown = spell.cooldown
				bar_speed = 100 / cooldown
				cooldown_timer.start(cooldown)
				
			Spell.SPELL_TYPE.CHARGEABLE:
				if state == STAFF_STATES.IDLE:
					spell = spell_scene.instantiate() as Spell
					state = STAFF_STATES.CHARGING
					
					get_tree().root.add_child(spell)
					spell.transform = muzzle.global_transform
				
				charge_held_time += delta
				
				if Input.is_action_just_released("shoot"):
					print("release")
					spell.cast(charge_held_time)
					is_on_cooldown = true
					cooldown = spell.cooldown
					bar_speed = 100 / cooldown
					cooldown_timer.start(cooldown)

func _on_timer_timeout() -> void:
	progress = 0
	is_on_cooldown = false
	state = STAFF_STATES.IDLE
