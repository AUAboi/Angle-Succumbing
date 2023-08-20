extends Control

@onready var heartUIFull: TextureRect = $HealthUIFull
@onready var heartUIEmpty: TextureRect = $HealthUIEmpty

var hearts: int =  4:
	get: 
		return hearts
	set(value): 
		hearts = clamp(value, 0, max_hearts)
		if heartUIFull != null:
			heartUIFull.size.x = hearts * 15
		
var max_hearts: int = 4:
	get: 
		return max_hearts
	set(value):
		max_hearts = max(value, 1)
		self.hearts = min(hearts, max_hearts)
		if heartUIEmpty != null:
			heartUIEmpty.size.x = max_hearts * 15

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	
	PlayerStats.health_changed.connect(
		func (value): 
			hearts = value
	)

	PlayerStats.max_health_changed.connect(
		func(value):
			max_hearts = value
	)
	
