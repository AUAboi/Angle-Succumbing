extends Area2D

class_name Spell

enum SPELL_TYPE {NORMAL, CHARGEABLE}

@export var speed: float
@export var cooldown: float
@export var deletion_time: float 

@export var type: SPELL_TYPE = SPELL_TYPE.NORMAL
