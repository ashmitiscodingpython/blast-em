extends Sprite2D

var time = 0
@onready var player = $"../Player"

func _process(_delta: float) -> void:
	time += _delta * 3
	rotation_degrees -= 3
	#scale = Vector2(0.5, 0.5) + (Vector2(sin(time) + 1, sin(time) + 1) / 4)
	var distance = position.distance_to(player.position)
	if distance < 75:
		position += (player.position - position) / 5
	if distance < 10:
		player.coins += 1
		queue_free()
