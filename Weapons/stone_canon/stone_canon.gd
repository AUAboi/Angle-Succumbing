extends Spell

@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum SPELL_STATES { IDLE, CHARGING, SHOT }

var state: SPELL_STATES = SPELL_STATES.IDLE 

func _ready() -> void:
	animated_sprite_2d.play("default")

func cast(charge_time: float) -> void:
	print(charge_time)
	if(charge_time > 3):
		scale = Vector2(1.5, 1.5)
		
	state = SPELL_STATES.SHOT
	timer.start(deletion_time)

func _physics_process(delta: float) -> void:
	match state:
		SPELL_STATES.CHARGING:
			pass
		SPELL_STATES.SHOT:
			position += transform.x * speed * delta

func _on_timer_timeout() -> void:
	queue_free()

func _on_hitbox_area_entered(_area: Area2D) -> void:
	queue_free()
