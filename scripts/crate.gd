extends StaticBody2D

@onready var player = $"../Player"
var time = 0.0

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	time += _delta
	var distance = sqrt(pow(position.x - player.position.x, 2) + pow(position.y - player.position.y, 2))
	if distance < 48:
		$"Expandable UI".open = true
	else:
		$"Expandable UI".open = false
