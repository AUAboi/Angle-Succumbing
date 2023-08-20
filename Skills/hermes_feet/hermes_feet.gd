extends Node

@export var dash_speed: float = 400.0
@export var cooldown: float = 1.0

#40% speed buff will be gained
@export var speed_buff: float = 40 d

@onready var cooldownTimer: Timer = $Cooldown
@onready var timer: Timer = $Timer

var initial_entity_speed

func execute(entity: CharacterBody2D, direction: Vector2):
	if (!cooldownTimer.is_on_cooldown):
		entity.velocity += entity.position.direction_to(direction) * dash_speed
		
		cooldownTimer.start_cooldown(cooldown)
		
		initial_entity_speed = entity.speed
		
		entity.speed += speed_buff
		
		timer.start(4)
		
		
		#maybe set emit to increase speed or any other bu
		timer.timeout.connect(
			func():
				entity.speed = initial_entity_speed
		)
