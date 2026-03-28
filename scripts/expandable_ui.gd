extends Node2D

@export var size = Vector2(0, 0)
@export var closed_position = Vector2(576, 800)
@export var process = true
@export var open = false
var open_position
var mouse = false
var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if !open:
		visible = false
	open_position = position

func _process(_delta: float) -> void:
	var cond = (closed_position.x - position.x < 1) and (closed_position.y - position.y < 1)
	if !open and cond:
		visible = true
	if open and process:
		position += (open_position - position) / 5
	else:
		position += (closed_position - position) / 5
	if process:
		if mouse:
			$Close/Sprite.scale += (Vector2(1.2, 1.2) - $Close/Sprite.scale) / 5
		else:
			$Close/Sprite.scale += (Vector2(0.85, 0.85) - $Close/Sprite.scale) / 5
		$Center.size.x = size.x + 18
		$Center.size.y = size.y + 18
		$Center.position = Vector2(
			-9 - (size.x / 2),
			-9 - (size.y / 2)
		)
		$"Bottom Edge".size.x = size.x + 16
		$"Bottom Edge".position = Vector2(-8 - (size.x / 2.0), 8 + (size.y / 2.0))
		$"Top Edge".size.x = size.x + 16
		$"Top Edge".position = Vector2(-8 - (size.x / 2.0), -24 - (size.y / 2.0))
		$"Left Edge".size.y = 16 + size.y
		$"Left Edge".position = Vector2(-24 - (size.x / 2.0), -8 - (size.y / 2.0))
		$"Right Edge".size.y = 16 + size.y
		$"Right Edge".position = Vector2(8 + (size.x / 2.0), -8 - (size.y / 2.0))
		$"Bottom Right".position = Vector2(16 + (size.x / 2.0), 16 + (size.y / 2.0))
		$"Bottom Left".position = Vector2(-16 - (size.x / 2.0), 16 + (size.y / 2.0))
		$"Top Right".position = Vector2(16 + (size.x / 2.0), -16 - (size.y / 2.0))
		$"Top Left".position = Vector2(-16 - (size.x / 2.0), -16 - (size.y / 2.0))

func _mouse() -> void:
	if !mouse:
		player.ui += 1
	mouse = true

func _mouse_left() -> void:
	if mouse:
		player.ui -= 1
	mouse = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if mouse:
			open = !open
