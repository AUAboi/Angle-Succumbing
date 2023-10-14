extends Area2D

@export var target_limit := 4
@export var damage := 99
@export var curse_time := 5

@onready var curse_timer: Timer = $CurseTimer
@onready var death_timer: Timer = $DeathTimer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D  

var DEATH_EFFECT_DELAY := 2

var DeathCurseCircle: PackedScene = preload("res://Supers/death_curse/death_curse_circle.tscn")
var target_enemies: Array[Area2D]

var shader_effect: Shader = preload("res://Effects/curse_effect.gdshader")

func execute() -> void:
	if(not curse_timer.is_stopped()):
		return
	
	target_enemies = get_overlapping_areas()
	
	if(target_enemies.size() > target_limit):
		var extra_size: int = target_limit - target_enemies.size()
		target_enemies.shuffle()
		target_enemies = target_enemies.slice(0, extra_size - 1)
	
	for hb_enemy in target_enemies:
		var enemy: Enemy = hb_enemy.get_parent()
		var death_curse_circle: AnimatedSprite2D = DeathCurseCircle.instantiate()
		
		enemy.add_child(death_curse_circle)
		
		curse_timer.start(curse_time)

func _on_curse_timer_timeout() -> void:
	if(target_enemies.size() > 0):
		for hb_enemy in target_enemies:
			if(not hb_enemy == null):
				var enemy: Enemy = hb_enemy.get_parent() as Enemy
				enemy.sprite.material = ShaderMaterial.new()
				enemy.sprite.material.shader = shader_effect
				enemy.process_mode = Node.PROCESS_MODE_DISABLED
		
		death_timer.start(DEATH_EFFECT_DELAY)


func _on_death_timer_timeout() -> void:
	if(target_enemies.size() > 0):
		for hb_enemy in target_enemies:
			if(not hb_enemy == null):
				var enemy: Enemy = hb_enemy.get_parent() as Enemy
				enemy.stats.health -= damage
