extends Area2D

var DeathCurseCircle: PackedScene = preload("res://Supers/death_curse/death_curse_circle.tscn")

@export var target_limit := 4
@export var damage := 99
@export var curse_time := 5


func execute() -> void:
	var target_enemies: Array[Area2D] = get_overlapping_areas()
	
	if(target_enemies.size() > target_limit):
		var extra_size: int = target_limit - target_enemies.size()
		target_enemies.shuffle()
		target_enemies = target_enemies.slice(0, extra_size - 1)
	
	for hb_enemy in target_enemies:
		var enemy: Enemy = hb_enemy.get_parent()
		var death_curse_circle: AnimatedSprite2D = DeathCurseCircle.instantiate()
		var curseTimer := Timer.new()
		
		curseTimer.set_one_shot(true)
		curseTimer.timeout.connect(_on_death_curse_circle_timeout)
		
		enemy.add_child(death_curse_circle)
		
		add_child(curseTimer)
		curseTimer.start(curse_time)

func _on_death_curse_circle_timeout() -> void:
	print("boom")
