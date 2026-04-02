extends TileMapLayer

var held = false
var erasing = false
var ons = {}
var appended = false
var tile_pos
var selecting = false
var selected_total = 0
@onready var cursor = $"../Selection Cursor"

func update_cells():
	clear()
	var tiles_to_update = []
	for key in ons:
		if ons[key]:
			tiles_to_update.append(key)
	set_cells_terrain_connect(tiles_to_update, 0, 0)

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var now = Vector2i(floor(mouse_pos.x / 16), floor(mouse_pos.y / 16)) + Vector2i(36, 20)
	if tile_pos != now:
		tile_pos = now
		appended = false
	if selecting:
		cursor.visible = true
	else:
		cursor.visible = false
	if held and $"../SubViewport/revelation".get_cell_source_id(tile_pos) > 0 and !appended and selecting:
		appended = true
		if !erasing and selected_total < $"../CanvasLayer/Upgrade Menu/Upgrade Button".totalable:	
			ons[tile_pos] = true
			if !get_cell_tile_data(tile_pos):
				selected_total += 1
		elif get_cell_source_id(tile_pos) > -1 and erasing:
			ons[tile_pos] = false
			selected_total -= 1
		update_cells()
	cursor.position = (((tile_pos - Vector2i(36, 20)) as Vector2) * Vector2(16, 16)) + Vector2(8, 8)
	if $"../SubViewport/revelation".get_cell_source_id(tile_pos) > 0:
		cursor.modulate = Color(1, 1, 1, 1)
	else:
		cursor.modulate = Color(0.5, 0.5, 0.5, 1)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		held = event.pressed
		if event.button_index == MOUSE_BUTTON_RIGHT:
			erasing = true
			appended = false
		else:
			erasing = false
			appended = false
