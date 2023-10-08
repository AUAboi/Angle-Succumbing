extends Sprite2D

@export var Spell: PackedScene = preload("res://Weapons/fireball.tscn")

@onready var muzzle: Marker2D = $Muzzle
@onready var timer: Timer = $Timer
@onready var bar: Control = $ReloadBar

var progress: float = 0.00
var is_on_cooldown: bool = false
var cooldown : float
var bar_speed: float 

func _process(_delta: float) -> void:
	bar.set_value(progress)
	if is_on_cooldown:
		progress = timer.time_left * bar_speed

func shoot() -> void:
	if !is_on_cooldown:
		var spell: Area2D = Spell.instantiate()
		get_tree().root.add_child(spell)
		spell.transform = muzzle.global_transform
		is_on_cooldown = true
		cooldown = spell.cooldown
		bar_speed = 100 / cooldown
		timer.start(cooldown)

func _on_timer_timeout() -> void:
	progress = 0
	is_on_cooldown = false
