extends Area2D

@export var speed: float = 200
@export var cooldown: float = 2.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("fire")

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_hitbox_area_entered() -> void:
	queue_free()
	
func _on_animation_player_animation_finished(_anim_name: String) -> void:
	queue_free()
