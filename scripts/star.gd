extends Sprite2D

var time = 0
var player_
var shown = false
@export var key = false

func _ready() -> void:
	if get_groups().find("Show") > -1:
		shown = true
	else:
		if $"..".name == "Keys":
			player_ = $"../../Player"
		else:
			player_ = $"../Player"

func _process(_delta: float) -> void:
	time += _delta * 3
	if !key:
		rotation_degrees -= 3
	#scale = Vector2(0.5, 0.5) + (Vector2(sin(time) + 1, sin(time) + 1) / 4)
	if !shown:
		var distance = position.distance_to(player_.position)
		if distance < 75:
			position += (player_.position - position) / 5
		if distance < 10:
			player_.get_child(1).playing = true
			if !key:
				player_.coins += 1
			else:
				player_.keys += 1
				if player_.keys == 1:
					var canvas = get_tree().get_first_node_in_group("Canvas")
					canvas.get_child(1).visible = true
					canvas.get_child(2).visible = true
			queue_free()
