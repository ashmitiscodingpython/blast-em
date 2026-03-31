extends Area2D

var mouse = false
@onready var player = $"../../Player"

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if mouse:
		scale += (Vector2(1.2, 1.2) - scale) / 5
	else:
		scale += (Vector2(1, 1) - scale) / 5
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if mouse:
			$"../Upgrade Menu".open = !$"../Upgrade Menu".open

func _mouse_on() -> void:
	if !mouse:
		player.ui += 1
	mouse = true

func _mouse_off() -> void:
	if mouse:
		player.ui -= 1
	mouse = false
