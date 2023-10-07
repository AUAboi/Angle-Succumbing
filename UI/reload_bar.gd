extends Control

@onready var textureProgressBar: TextureProgressBar = $TextureProgressBar

func set_value(value: float) -> void:
	textureProgressBar.value = value
