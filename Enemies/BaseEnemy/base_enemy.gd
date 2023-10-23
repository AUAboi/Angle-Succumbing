extends CharacterBody2D

class_name Enemy

@export var acceleration: float = 300.0
@export var speed: float = 60.0
@export var friction: float = 200.0
@export var push_factor: float = 500.0

@onready var sprite: Sprite2D = $Sprite2D 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var stats: Node = $Stats 
@onready var soft_collision: Area2D = $SoftCollision
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var state_machine: StateMachine = $StateMachine

var HitEffect: PackedScene = preload("res://Effects/hit_effect.tscn")
var DeathEffect: PackedScene = preload("res://Effects/enemy_death_effect.tscn")

var player_direction: Vector2 = Vector2.ZERO

#Improve this and every procedure where its used
var is_dead: bool = false

func _ready() -> void:
	animation_player.play("default")
	
func play_death_effect() -> void:
	queue_free()
	var death_effect: AnimatedSprite2D = DeathEffect.instantiate()
	get_tree().current_scene.add_child(death_effect)
	death_effect.global_position = global_position
	

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if("knockback" in area):
		var knockback_direction = -global_position.direction_to(area.global_position)
		velocity = knockback_direction * area.knockback
	
	stats.health -= area.damage
	hurtbox.create_hit_effect()

func _on_stats_no_health() -> void:
	if !is_dead:
		is_dead = true
		animation_player.play("death_anim_default")
	else:
		play_death_effect()
