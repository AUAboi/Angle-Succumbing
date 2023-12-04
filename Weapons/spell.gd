extends Area2D

class_name Spell

enum SpellStates { 
	IDLE, 
	CHARGING, 
	CHARGED, 
	SHOT, 
}

var spell_state: SpellStates = SpellStates.IDLE 

@export var spell_stats: SpellStats

@onready var hitbox: Hitbox = $Hitbox

func _ready() -> void:
	hitbox.damage = spell_stats.damage
	hitbox.knockback = spell_stats.knockback
	is_ready()

#Virtual function to extend _ready
func is_ready() -> void:
	pass
