extends Node

@export var dash_speed: float = 400.0
@export var cooldown: float = 0.5

@onready var timer: Timer = $Cooldown

func execute(entity: CharacterBody2D, direction: Vector2):
	if (!timer.is_on_cooldown):
		entity.velocity += entity.position.direction_to(direction) * dash_speed
		timer.start_cooldown(cooldown)

