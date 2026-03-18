extends CharacterBody2D

var input = Vector2()
@onready var sprite = $Sprite2D
@onready var animator = $AnimationPlayer
@onready var weapon = $weapon
@export var speed := 200
@export var accel := 1200.0
@export var friction := 1400.0
@onready var ground = $"../Main"
@onready var layers: Array[TileMapLayer] = [$"../Main", $"../Layer 1", $"../Layer 2"]
var on_stair = false
var wep = Vector2()
var input_dir
var z = 0
var last_tile
var current_layer: TileMapLayer
var behind = false
var col = false
var full = PackedVector2Array()
var held = false
var cooldown = 0
var laye = 0
var stair_tile
var coins = 0

func turn_off_collision(from):
	var i = 0
	for layer in layers:
		if i >= from:
			layer.collision_enabled = false
			layer.z_index = 4
		i += 1

func alpha(from):
	var i = 0
	for layer in layers:
		if i >= from:
			layer.modulate = Color(1.0, 1.0, 1.0, 0.5)
		i += 1

func nalpha():
	for layer in layers:
		layer.modulate = Color(1, 1, 1)

func reset_collision():
	for layer in layers:
		layer.collision_enabled = true
		layer.z_index = 0

func layer_no(get_data:bool=false):
	for layer in layers:
		var data = get_tile_data(layer)
		if data:
			@warning_ignore("incompatible_ternary")
			return layers.find(layer) if not get_data else [layers.find(layer), data]

func get_tile_data(layer:TileMapLayer):
	var tile = layer.local_to_map(global_position)
	var data: TileData = layer.get_cell_tile_data(tile)
	return data

func direction(target: Vector2):
	return atan2((position.y - target.y), (position.x - target.x))

func _ready() -> void:
	var tiles: TileSetSource = ground.tile_set.get_source(0) as TileSetAtlasSource
	stair_tile = tiles.get_tile_data(Vector2i(9, 2), 0)
	full = (layers[0].tile_set.get_source(0) as TileSetAtlasSource).get_tile_data(Vector2i(1, 3), 0).get_collision_polygon_points(0, 0)
	reset_collision()
	turn_off_collision(z + 1)
	Input.set_custom_mouse_cursor(preload("res://kenney_desert-shooter-pack_1.0/PNG/Weapons/Tiles/tile_0035.png"))

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var target_vel = input_dir * speed
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(target_vel, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()

func _process(_delta: float) -> void:
	var layer_data = layer_no(true)
	var az = layer_data[0]
	var data: TileData = layer_data[1]
	if data != last_tile and on_stair:
		reset_collision()
		turn_off_collision(az + 1)
		z = az
	if data.get_custom_data("Stair") and !behind:
		on_stair = true
	else:
		on_stair = false
	current_layer = layers[z]
	if cooldown > 0:
		cooldown += _delta
	if held and !cooldown > 0:
		$"../BulletSound".playing = true
		cooldown += _delta
		var bullet = load("res://scenes/node_2d.tscn").instantiate()
		bullet.position = $weapon.global_position
		bullet.rotation = $weapon.rotation + deg_to_rad(90)
		bullet.speed = 5
		bullet.z_index = laye
		get_tree().current_scene.add_child(bullet)
	if cooldown > 0.1:
		cooldown = 0
	if input_dir.x < 0:
		sprite.scale.x = -1
	elif input_dir.x > 0:
		sprite.scale.x = 1
	if input_dir != Vector2(0, 0) and not animator.is_playing():
		animator.play("walk")
	elif input_dir == Vector2(0, 0) and animator.is_playing():
		animator.stop()
		sprite.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Players/Tiles/tile_0000.png")
	weapon.rotation = direction(get_global_mouse_position()) + deg_to_rad(180)
	if weapon.rotation_degrees < 270 and weapon.rotation_degrees > 90:
		weapon.scale.y = -1
		wep = Vector2(-11, 0)
	else:
		weapon.scale.y = 1
		wep = Vector2(11, 0)
	weapon.position += (wep - weapon.position) / 5
	weapon.rotation = direction(get_global_mouse_position()) + deg_to_rad(180)
	
	last_tile = data
	if layer_data[0] > z:
		behind = true
	else:
		behind = false
	if behind and !col:
		col = true
		stair_tile.add_collision_polygon(0)
		stair_tile.set_collision_polygon_points(0, 0, full)
	elif !behind and col:
		col = false
		stair_tile.remove_collision_polygon(0, 0)
	if behind:
		laye = layer_data[0]
		alpha(z + 1)
	else:
		nalpha()
		laye = 15

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			held = true
		else:
			held = false
