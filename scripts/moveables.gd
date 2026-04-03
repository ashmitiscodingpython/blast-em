extends Node2D

var to_pos = Vector2(0, 0)
var switching = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	position += (to_pos - position) / 5
	if switching and abs(to_pos.y - position.y) < 3:
		get_tree().change_scene_to_file("res://node_2d.tscn")
