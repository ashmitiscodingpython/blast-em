extends Node2D

@export var size = Vector2(0, 0)
@export var process = true

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if process:
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
