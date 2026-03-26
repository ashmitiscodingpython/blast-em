extends Camera2D

var shake = 0
var fade = 20.0
@onready var reals = position

func _process(_delta: float) -> void:
	if shake > 0:
		shake += (0 - shake) / fade
	reals += ($"../Player".position - position) / 10
	position = reals + Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
