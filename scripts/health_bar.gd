extends Node2D

@export var health = 0
@onready var middleses = [$"Middle 1", $"Middle 2"]

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	$End.position.x = remap(health, 0, 100, -20, 24)
	for middle in middleses:
		if $End.position.x > middle.position.x:
			middle.visible = true
		else:
			middle.visible = false
