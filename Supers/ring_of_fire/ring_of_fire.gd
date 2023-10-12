extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func execute() -> void:
	if(not animation_player.is_playing()):
		animation_player.play("start")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
