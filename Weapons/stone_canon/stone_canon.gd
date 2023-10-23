extends Spell

@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var enemy_pass_count: int = 1

var charge_level: int = 0

func _ready() -> void:
	animated_sprite_2d.play("default")

func cast(charge_time: float) -> void:
	if charge_time > 3:
		enemy_pass_count = 2
		scale = Vector2(1.5, 1.5)
		
	spell_state = SpellStates.SHOT
	timer.start(deletion_time)

func casting(charge_time: float) -> void:
	if charge_time > 1.0 && charge_level == 0: 
		charge_level = 1
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(animated_sprite_2d, "speed_scale", 10, 3.0)

func _physics_process(delta: float) -> void:
	match spell_state:
		SpellStates.CHARGING:
			pass
		SpellStates.SHOT:
			position += transform.x * speed * delta

func _on_timer_timeout() -> void:
	queue_free()

func _on_hitbox_area_entered(_area: Area2D) -> void:
	enemy_pass_count -= 1
	if enemy_pass_count == 0:
		queue_free()
