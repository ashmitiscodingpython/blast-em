extends Sprite2D

func _process(_delta: float) -> void:
	position = $"../Crate UI".position + Vector2(5.5, 0) - (Vector2(12, 0) if $"..".golden else Vector2(0, 0))
	modulate = $"../Crate UI".modulate
	scale = $"../Crate UI".scale
	if $"..".golden:
		$"../Sprite2D".position = position + Vector2(29.5, 0)
		$"../Sprite2D".modulate = modulate
		$"../Sprite2D".scale = scale
