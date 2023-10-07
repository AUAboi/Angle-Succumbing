extends Sprite2D

@export var spell: PackedScene = preload("res://Weapons/fireball.tscn")

@onready var muzzle: Marker2D = $Muzzle
@onready var timer: Timer = $Timer
@onready var bar: Control = $ReloadBar

var progress: float = 0.00
var is_on_cooldown: bool = false
var cooldown : float
var bar_speed: float 

func _process(_delta: float):
	bar.set_value(progress)
	if is_on_cooldown:
		progress = timer.time_left * bar_speed

func shoot():
	if !is_on_cooldown:
		var Spell: Area2D = spell.instantiate()
		get_tree().root.add_child(Spell)
		Spell.transform = muzzle.global_transform
		is_on_cooldown = true
		cooldown = Spell.cooldown
		bar_speed = 100 / cooldown
		timer.start(cooldown)
	

func _on_timer_timeout():
	progress = 0
	is_on_cooldown = false
