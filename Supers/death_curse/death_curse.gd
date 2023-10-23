extends Area2D

@export var target_limit := 4
@export var damage := 99
@export var curse_time := 5

@onready var curse_timer: Timer = $CurseTimer
@onready var death_timer: Timer = $DeathTimer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D  

var DEATH_EFFECT_DELAY := 2

var DeathCurseCircle: PackedScene = preload("res://Supers/death_curse/death_curse_circle.tscn")
var target_enemies: Array[Enemy]

var shader_effect: Shader = preload("res://Effects/curse_effect.gdshader")

func execute() -> void:
	if(not curse_timer.is_stopped() || not death_timer.is_stopped()):
		return
	
	var enemy_hitboxes: Array[Area2D] = get_overlapping_areas()
	
	if(enemy_hitboxes.size() > target_limit):
		enemy_hitboxes.shuffle()
		enemy_hitboxes = enemy_hitboxes.slice(0, target_limit)
		
	for hb_enemy in enemy_hitboxes:
		var enemy: Enemy = hb_enemy.get_parent()
		target_enemies.push_back(enemy)
		var death_curse_circle: AnimatedSprite2D = DeathCurseCircle.instantiate()
		
		enemy.add_child(death_curse_circle)
		
		curse_timer.start(curse_time)

func _on_curse_timer_timeout() -> void:
	if(target_enemies.size() > 0):
		for enemy in target_enemies:
			if(enemy != null):
				enemy.sprite.material = ShaderMaterial.new()
				enemy.sprite.material.shader = shader_effect
				enemy.is_dead = true
				enemy.process_mode = Node.PROCESS_MODE_DISABLED
		
		death_timer.start(DEATH_EFFECT_DELAY)

func _on_death_timer_timeout() -> void:
	if(target_enemies.size() > 0):
		for enemy in target_enemies:
			if(enemy != null):
				enemy.stats.health -= damage
	
	target_enemies = []
