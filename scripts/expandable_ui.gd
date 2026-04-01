extends Node2D

@export var size = Vector2(0, 0)
@export var closed_position = Vector2(576, 800)
@export var open_position: Vector2
@export var process = true
@export var open = false
@export var button = false
@export var text_included = false
@export var auto_set_open_position = true
@export var close_button = true

@export_group("Text")
@export var text: String
@export var constant = true
@export var relative_position = Vector2(0, 0)
@export var align = "center"

@export_group("Button Actions")
@export var filler: String = "FILLING IN"

var mouse = false
var player
var mouse_whole = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if !close_button:
		$"Close".queue_free()
	if !open:
		visible = false
	if auto_set_open_position:
		open_position = position
	if button:
		$Collider/CollisionShape2D.shape.size = size + Vector2(48, 48)

func _process(_delta: float) -> void:
	var cond = (closed_position.x - position.x < 1) and (closed_position.y - position.y < 1)
	if mouse_whole and button:
		scale += (Vector2(1.2, 1.2) - scale) / 5
	elif button:
		scale += (Vector2(1, 1) - scale) / 5
	if !open and cond:
		visible = true
	if open and process:
		position += (open_position - position) / 5
	else:
		position += (closed_position - position) / 5
	if process:
		if close_button:
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

func mouse_on() -> void:
	if button:
		mouse_whole = true

func mouse_off() -> void:
	if button:
		mouse_whole = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if mouse:
			open = !open
