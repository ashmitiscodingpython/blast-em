extends Node2D

@export var health = 0
@onready var middleses = []
var enemish = false
var length = 2
var start_pos
var cursor
var middle

func new_filler(x, num, end=false):
	var filler = Sprite2D.new()
	filler.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Interface/Tiles/tile_0122.png" if !end else "res://kenney_desert-shooter-pack_1.0/PNG/Interface/Tiles/tile_0124.png")
	filler.name = "Filler " + str(num)
	filler.position = Vector2(x, 0)
	filler.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	$"Filler".add_child.call_deferred(filler)

func _ready() -> void:
	start_pos = -((length - 1) * 8)
	cursor = start_pos + 16
	$Start.position.x = start_pos
	new_filler(start_pos + 4, 1)
	new_filler(-start_pos + 32, length + 2, true)
	middle = Sprite2D.new()
	middle.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Interface/Tiles/tile_0158.png")
	middle.name = "Middle"
	middle.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child.call_deferred(middle)
	for i in range(length):
		#var middle = Sprite2D.new()
		#middle.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Interface/Tiles/tile_0158.png")
		#middle.name = "Middle " + str(i + 1)
		#middle.position = Vector2(cursor, 0)
		#middle.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		#add_child.call_deferred(middle)
		#middleses.append(middle)
		new_filler(cursor, i + 2)
		cursor += 16
	if enemish:
		$Start.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Interface/Tiles/tile_0139.png")
		#for middle in middleses:
		#	middle.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Interface/Tiles/tile_0140.png")
		$End.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Interface/Tiles/tile_0142.png")

func _process(_delta: float) -> void:
	$End.position.x = remap(health, 0, 100, start_pos + 4, -start_pos + 32)
	middle.scale.x = remap(health, 0, 100, 0, length)
	middle.position.x = ($End.position.x + $Start.position.x) / 2
	#for middle in middleses:
	#	if $End.position.x > middle.position.x + 2:
	#		middle.visible = true
	#	else:
	#		middle.visible = false
