extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

func set_value(value: float) -> void:
	texture_progress_bar.value = value
