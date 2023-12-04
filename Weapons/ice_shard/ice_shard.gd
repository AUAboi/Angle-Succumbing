extends Spell

@onready var timer: Timer = $Timer

func is_ready() -> void:
	timer.start(spell_stats.deletion_time)

func _physics_process(delta: float) -> void:
	position += transform.x * spell_stats.speed * delta

func _on_timer_timeout() -> void:
	queue_free()

func _on_hitbox_area_entered(_area: Area2D) -> void:
	queue_free()
