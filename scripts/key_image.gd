extends Sprite2D

func _process(_delta: float) -> void:
	position = $"../Crate UI".position + Vector2(5.5, 0)
	modulate = $"../Crate UI".modulate
