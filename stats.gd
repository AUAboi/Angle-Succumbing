extends Node2D

signal no_health
signal health_changed(value: int)
signal max_health_changed(value: int)

@export var max_health: int = 1: 
	get: 
		return max_health
	set(value):
		max_health = value
		self.health = min(health, max_health)
		emit_signal("max_health_changed", value)

@onready var health: int = max_health:
	get: 
		return health
	set(value): 
		emit_signal("health_changed", value)
		health = value
		if health <= 0:
			emit_signal("no_health")
		
