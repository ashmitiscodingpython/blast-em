extends StaticBody2D

@onready var player = $"../Player"
var time = 0.0
var wasted = false
@export var golden = false

func _ready() -> void:
	visible = true
	if golden:
		$Crate.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Tiles/Tiles/tile_0218.png")

func _process(_delta: float) -> void:
	time += _delta
	var distance = sqrt(pow(position.x - player.position.x, 2) + pow(position.y - player.position.y, 2))
	if distance < 48 and !wasted and ! $"Crate UI".paused:
		$"Crate UI".open = true
	else:
		$"Crate UI".open = false
