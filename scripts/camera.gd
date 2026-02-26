extends Camera2D

func _process(_delta: float) -> void:
	position += ($"../Player".position - position) / 5
