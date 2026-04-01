extends TileMapLayer

var held = false
var erasing = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var tile_pos = Vector2i(floor(mouse_pos.x / 16), floor(mouse_pos.y / 16))
	if held and $"../SubViewport/revelation".get_cell_source_id(tile_pos) > 0:
		if !erasing:	
			set_cells_terrain_connect([tile_pos], 0, 0)
		elif get_cell_source_id(tile_pos) > -1:
			erase_cell(tile_pos)
			var neighbours = [
				tile_pos + Vector2i(0, 1),
				tile_pos + Vector2i(1, 0),
				tile_pos + Vector2i(-1, 0),
				tile_pos + Vector2i(0, -1),
				tile_pos + Vector2i(1, 1),
				tile_pos + Vector2i(-1, -1),
				tile_pos + Vector2i(1, -1),
				tile_pos + Vector2i(-1, 1)
			]
			for neighbour in neighbours:
				if get_cell_source_id(neighbour) < 0:
					neighbours.pop_at(neighbours.find(neighbour))
					set_cells_terrain_connect([neighbour], 0, 0, false)
			print(tile_pos, " ", neighbours)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		held = event.pressed
		if event.button_index == MOUSE_BUTTON_RIGHT:
			erasing = true
		else:
			erasing = false
