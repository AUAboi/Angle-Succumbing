extends Area2D

@export var target_limit := 4
@export var damage := 99
@export var curse_time := 5

@onready var curse_timer: Timer = $CurseTimer

var DeathCurseCircle: PackedScene = preload("res://Supers/death_curse/death_curse_circle.tscn")
var target_enemies: Array[Area2D]

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
	for hb_enemy in target_enemies:
		var enemy := hb_enemy.get_parent() as Enemy
		enemy.stats.health -= damage
	
	target_enemies = []
