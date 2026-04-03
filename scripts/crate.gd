extends StaticBody2D

@onready var player = $"../Player"
var time = 0.0
var wasted = false

func _ready() -> void:
	visible = true

func _process(_delta: float) -> void:
	if $"../EnemySpawner".disabled:
		queue_free()
	time += _delta
	var distance = sqrt(pow(position.x - player.position.x, 2) + pow(position.y - player.position.y, 2))
	if distance < 48 and !wasted:
		$"Crate UI".open = true
	else:
		$"Crate UI".open = false
