extends AnimatedSprite2D

func _ready():
	play("hit")
	animation_finished.connect(queue_free)
