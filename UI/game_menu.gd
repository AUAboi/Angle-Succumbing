extends Control

@onready var start_button: Label = $VBoxContainer/GameStart



func _on_game_start_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().change_scene_to_file("res://world.tscn")
