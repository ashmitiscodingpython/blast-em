extends Node2D

var positions = Vector2(73, 170)

func set_posses():
	$"../Selection Display".position = positions
	$"../SLASH".position = positions + Vector2(109, 0)
	$"../Selection Counter".position = positions + Vector2(77, 0)

func _ready() -> void:
	set_posses()

func _process(_delta: float) -> void:
	$"../Selection Display".visible = visible
	$"../SLASH".visible = visible
	$"../Selection Counter".visible = visible
	$"../Selection Indicator".visible = visible
