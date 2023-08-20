extends Area2D

@export var speed: float = 200
@export var cooldown: float = 2.0

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("fire")

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_hitbox_area_entered():
	queue_free()

func _on_animation_player_animation_finished():
	queue_free()
