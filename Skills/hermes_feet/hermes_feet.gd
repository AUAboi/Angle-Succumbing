extends Node

@export var dash_speed: float = 400.0
@export var cooldown: float = 1.0

#40% speed buff will be gained
@export var speed_buff: float = 40

@onready var cooldownTimer: Timer = $Cooldown
@onready var timer: Timer = $Timer

var initial_entity_speed: float
var player_entity: Player

func execute(entity: Player, direction: Vector2):
	player_entity = entity
	if (!cooldownTimer.is_on_cooldown):
		player_entity.velocity += player_entity.position.direction_to(direction) * dash_speed
		cooldownTimer.start_cooldown(cooldown)
		initial_entity_speed = player_entity.speed
		player_entity.speed += speed_buff
		timer.start(2)

func _on_timer_timeout() -> void:
	player_entity.speed = initial_entity_speed
