extends Sprite2D

var speed = 2
var time = 0

func _process(_delta: float) -> void:
	rotation_degrees -= 90
	position += Vector2(cos(rotation) * speed, sin(rotation) * speed)
	rotation_degrees += 90
	time += _delta
	if time > 8:
		queue_free()
