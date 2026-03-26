extends Sprite2D

var time = 0
var player_
var shown = false

func _ready() -> void:
	if get_groups().find("Show") > -1:
		shown = true
	else:
		player_ = $"../Player"

func _process(_delta: float) -> void:
	time += _delta * 3
	rotation_degrees -= 3
	#scale = Vector2(0.5, 0.5) + (Vector2(sin(time) + 1, sin(time) + 1) / 4)
	if !shown:
		var distance = position.distance_to(player_.position)
		if distance < 75:
			position += (player_.position - position) / 5
		if distance < 10:
			player_.coins += 1
			queue_free()
