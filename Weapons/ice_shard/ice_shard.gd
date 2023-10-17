extends Area2D


@export var speed: float = 200
@export var cooldown: float = 0.2

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start(5)

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_hitbox_area_entered() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
