extends Node2D

@export var health = 0
@onready var middleses = []
@export var length = 2
@export var enemish = false
@export var selongation: float = 0.687
var start_pos
var cursor

func new_filler(x, num, end=false):
	var filler = Sprite2D.new()
	filler.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Interface/Tiles/tile_0122.png" if !end else "res://kenney_desert-shooter-pack_1.0/PNG/Interface/Tiles/tile_0124.png")
	filler.name = "Filler " + str(num)
	filler.position = Vector2(x, 0)
	filler.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	$"Filler".add_child.call_deferred(filler)

func _ready() -> void:
	start_pos = -((length + 1) * 8)
	cursor = start_pos + 16
	$Start.position.x = start_pos
	new_filler(start_pos + 4, 1)
	new_filler(-start_pos, length + 2, true)
	for i in range(length):
		new_filler(cursor, i + 2)
		cursor += 16
	if enemish:
		$"Start/Short Start".texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Interface/Tiles/tile_0143.png")
		$"End/Short End".texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Interface/Tiles/tile_0143.png")
		$"Start/Start Elongation".texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Interface/Tiles/tile_0140.png")

func _process(_delta: float) -> void:
	$End.position.x = remap(health, 0, 100, start_pos, -start_pos + 7)
	selongation = clamp(remap(health, 0, 100, 0, 1.38 + length), 0, 1000000)
	$"Start/Start Elongation".scale.x = selongation
