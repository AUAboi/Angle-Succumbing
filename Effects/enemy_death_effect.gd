extends AnimatedSprite2D

func _ready():
	play("animate")
	
	animation_finished.connect(queue_free)
