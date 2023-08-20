extends Area2D

signal invincibilty_started
signal invincibilty_ended

@onready var timer: Timer = $Timer
@onready var HitEffect: PackedScene = preload("res://Effects/hit_effect.tscn")

var invincible: bool = false: 
	get:
		return invincible
	set(val):
		invincible = val
		if invincible:
			emit_signal("invincibilty_started")
		else:
			emit_signal("invincibilty_ended")

func start_invincibilty(duration: float):
	self.invincible = true
	timer.start(duration)

func end_invincibilty():
	timer.emit_signal("timeout")

func create_hit_effect():
	var hitEffect = HitEffect.instantiate()
	get_tree().current_scene.add_child(hitEffect)
	hitEffect.global_position = global_position

func _on_timer_timeout():
	self.invincible = false

func _on_invincibilty_started():
	set_deferred("monitoring", false)

func _on_invincibilty_ended():
	#this is not called in physics process so deffered is not needed
	monitoring = true
	
