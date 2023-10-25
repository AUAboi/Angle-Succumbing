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
