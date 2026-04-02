extends Sprite2D

func _process(_delta: float) -> void:
	position = $"../Expandable UI".position + Vector2(5.5, 0)
	modulate = $"../Expandable UI".modulate
