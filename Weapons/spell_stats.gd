extends Resource

class_name SpellStats

enum SpellTypes { 
	NORMAL, 
	CHARGEABLE, 
}

@export var name := ""
@export_multiline var description := ""

@export var icon:Texture2D
@export var damage := 0
@export var knockback := 0
@export var cooldown := 0
@export var speed: float
@export var deletion_time: float 

@export var type: SpellTypes

@export var custom_var := {}
