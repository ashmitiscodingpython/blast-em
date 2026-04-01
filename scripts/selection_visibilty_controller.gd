extends Node2D

func _process(_delta: float) -> void:
	$"../Selection Display".visible = visible
	$"../SLASH".visible = visible
	$"../Selection Counter".visible = visible
	$"../Selection Indicator".visible = visible
