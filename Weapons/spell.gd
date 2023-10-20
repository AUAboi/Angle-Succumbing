extends Area2D

class_name Spell

enum SpellTypes {NORMAL, CHARGEABLE}
enum SpellStates { IDLE, CHARGING, CHARGED, SHOT }

@export var speed: float
@export var cooldown: float
@export var deletion_time: float 

@export var type: SpellTypes = SpellTypes.NORMAL

var spell_state: SpellStates = SpellStates.IDLE 
