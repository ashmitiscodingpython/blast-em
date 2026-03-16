extends TextureRect

func _ready() -> void:
	texture = $"../SubViewport".get_texture()
