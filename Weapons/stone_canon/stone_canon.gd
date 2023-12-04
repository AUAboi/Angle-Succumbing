extends Spell

@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var enemy_pass_count := 1

var _charge_level := 0
var _held_time := 0.0

func is_ready() -> void:
	animated_sprite_2d.play("default")

func _physics_process(delta: float) -> void:
	match spell_state:
		SpellStates.CHARGING:
			_held_time += delta
			if _held_time > 1.0 && _charge_level == 0: 
				_charge_level = 1
				var tween := get_tree().create_tween()
				tween.tween_property(animated_sprite_2d, "speed_scale", 10, 3.0)
				tween.tween_property(self, "scale", Vector2(2.5, 2.5), 1.0)
				
		SpellStates.SHOT:
			position += transform.x * spell_stats.speed * delta

func cast() -> void:
	if _held_time > 3.0:
		enemy_pass_count = 2
	
	_held_time = 0.0
	spell_state = SpellStates.SHOT
	timer.start(spell_stats.deletion_time)

func _on_timer_timeout() -> void:
	queue_free()

func _on_hitbox_area_entered(_area: Area2D) -> void:
	enemy_pass_count -= 1
	if enemy_pass_count == 0:
		queue_free()
