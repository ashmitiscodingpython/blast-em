extends TileMapLayer

var held = false
var erasing = false
var ons = {}
var appended = false
var tile_pos
var selecting = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var now = Vector2i(floor(mouse_pos.x / 16), floor(mouse_pos.y / 16))
	if tile_pos != now:
		tile_pos = now
		appended = false
	if held and $"../SubViewport/revelation".get_cell_source_id(tile_pos) > 0 and !appended and selecting:
		appended = true
		if !erasing:	
			ons[tile_pos] = true
		elif get_cell_source_id(tile_pos) > -1:
			ons[tile_pos] = false
		clear()
		var tiles_to_update = []
		for key in ons:
			if ons[key]:
				tiles_to_update.append(key)
		set_cells_terrain_connect(tiles_to_update, 0, 0)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		held = event.pressed
		if event.button_index == MOUSE_BUTTON_RIGHT:
			erasing = true
			appended = false
		else:
			erasing = false
			appended = false
