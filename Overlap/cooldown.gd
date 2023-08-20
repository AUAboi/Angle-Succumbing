extends Timer


var is_on_cooldown: bool = false

signal cooldown_ended

func start_cooldown(time: float):
	is_on_cooldown = true
	start(time)

func _on_timeout():
	is_on_cooldown = false
	emit_signal("cooldown_ended", is_on_cooldown)
