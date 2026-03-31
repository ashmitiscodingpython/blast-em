extends TileMapLayer



func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var tile_pos = Vector2(floor(mouse_pos.x / 16), floor(mouse_pos.y / 16))
	set_cells_terrain_connect([tile_pos], 0, 0)
