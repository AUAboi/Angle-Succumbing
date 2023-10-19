extends Spell

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start(deletion_time)

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_timer_timeout() -> void:
	queue_free()

func _on_hitbox_area_entered(_area: Area2D) -> void:
	queue_free()
