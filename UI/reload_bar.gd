extends Control

@onready var textureProgressBar: TextureProgressBar = $TextureProgressBar

func set_value(value):
	textureProgressBar.value = value
