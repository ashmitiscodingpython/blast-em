extends CharacterBody2D
class_name playerscript

var input = Vector2()
@onready var sprite = $Sprite2D
@onready var animator = $AnimationPlayer
@onready var weapon = $weapon
@export var speed := 200
@export var accel := 1200.0
@export var friction := 1400.0
@onready var ground = $"../Main"
@onready var layers: Array[TileMapLayer] = [$"../Main", $"../Layer 1", $"../Layer 2", $"../Layer 3"]
@onready var collayers: Array[TileMapLayer] = [$"../Pure Collision 1", $"../Pure Collision 2", $"../Pure Collision 3"]
var on_stair = false
var wep = Vector2()
var input_dir
var z = 0
var last_tile
var current_layer: TileMapLayer
var behind = false
var col = true
var full = PackedVector2Array()
var held = false
var cooldown = 0
var laye = 0
var stair_tile
var coins = 0
var bar = load("res://scenes/health.tscn").instantiate()
@export var health = 500
var upordown = 0
var assigned = false
var tick = false
var enemies_on = []
signal damage
var ui = 0
var keys = 0
var chosen_gun

func spawn_bullet(current):
	var bullet = load("res://scenes/node_2d.tscn").instantiate()
	bullet.position = $weapon.global_position
	var rotadd = randf_range(-current["Accuracy"], current["Accuracy"])
	if $"../Guns Info".current_gun == "Bazooka":
		bullet.bazooka = true
	bullet.rotation = $weapon.rotation + deg_to_rad(90) + deg_to_rad(rotadd)
	bullet.speed = current["Firepower"]
	bullet.z_index = laye
	get_tree().current_scene.add_child(bullet)

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
	
func rescol():
	for collayer in collayers:
		collayer.collision_enabled = false

func colfrom(layer: int):
	var i = 0
	for collayer in collayers:
		collayer.collision_enabled = true
		if i >= layer:
			collayer.collision_enabled = false
		i += 1

func layer_no(get_data:bool=false):
	for layer in layers:
		var data = get_tile_data(layer)
		if data:
			@warning_ignore("incompatible_ternary")
			return layers.find(layer) if not get_data else [layers.find(layer), data]

func get_tile_data(layer: TileMapLayer):
	var tile = layer.local_to_map(global_position)
	var data: TileData = layer.get_cell_tile_data(tile)
	return data

func direction(target: Vector2):
	return atan2((position.y - target.y), (position.x - target.x))

func _ready() -> void:
	chosen_gun = $"../Guns Info".gun_names.pick_random()
	for collayer in collayers:
		collayer.modulate = Color(1, 1, 1, 0)
	bar.position = Vector2(0, 20)
	bar.scale = Vector2(0.5, 0.5)
	bar.length = 2
	add_child.call_deferred(bar)
	var tiles: TileSetSource = ground.tile_set.get_source(0) as TileSetAtlasSource
	stair_tile = tiles.get_tile_data(Vector2i(9, 2), 0)
	stair_tile.add_collision_polygon(0)
	full = (layers[0].tile_set.get_source(0) as TileSetAtlasSource).get_tile_data(Vector2i(1, 3), 0).get_collision_polygon_points(0, 0)
	reset_collision()
	turn_off_collision(z + 1)
	Input.set_custom_mouse_cursor(preload("res://kenney_desert-shooter-pack_1.0/PNG/Weapons/Tiles/tile_0025.png"))

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var target_vel = input_dir * speed
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(target_vel, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()

func _process(_delta: float) -> void:
	# IN CASE YOU FORGET AGAIN
	# To make a plateau, first add the bottom part
	# thingies at the lower level, then add the
	# actual plateau part on the next layer
	# the collayers are for the stairs. Wherever
	# there is a stair, add any full collision
	# tile to that coord for collayer [layer of
	# the stair + 1]
	# Also remove any tiles above a plateau
	# in the below layer
	var layer_data = layer_no(true)
	var az = layer_data[0]
	var data: TileData = layer_data[1]
	behind = az != z and !on_stair
	if data.get_custom_data("Stair"):
		on_stair = true
		if !assigned:
			assigned = true
			upordown = velocity.y / abs(velocity.y)
	else:
		on_stair = false
		assigned = false
	behind = az != z and !on_stair and !z > az
	tick = false
	if z > az and !on_stair:
		z = az
		tick = true
	var stair_req = on_stair and !behind and !z < az
	if stair_req or tick:
		if !tick:
			z = int(az - clamp(upordown, -1, 0))
		reset_collision()
		turn_off_collision(z + 1)
	if behind and !col:
		col = true
		nalpha()
		alpha(z + 1)
		rescol()
		colfrom(z + 1)
	elif !behind and col:
		if !(on_stair and !stair_req):
			col = false
			rescol()
			nalpha()
	
	ui = clamp(ui, 0, 100000)
	var cureffect = $"../CanvasLayer/Damage Overlay".material.get_shader_parameter("strength")
	$"../CanvasLayer/Damage Overlay".material.set_shader_parameter("strength", cureffect + ((0 - cureffect) / 5))
	var current = $"../Guns Info".current_details
	bar.health = health / 5.0
	if cooldown > 0:
		cooldown += _delta
	if held and !cooldown > 0:
		$"BulletSound".playing = true
		cooldown += _delta
		spawn_bullet(current)
		if $"../Guns Info".current_gun == "Shotgun":
			for i in range(3):
				spawn_bullet(current)
		var dir = $weapon.rotation + deg_to_rad(180)
		var recoil = Vector2(cos(dir), sin(dir)) * current["Recoil"]
		velocity += recoil * 15
	if current:
		weapon.texture = load(current["Sprite"])
		if cooldown > current["Reload"]:
			cooldown = 0
	if input_dir.x < 0:
		sprite.scale.x = -1
	elif input_dir.x > 0:
		sprite.scale.x = 1
	elif input_dir.x == 0:
		var dir = position.x - get_global_mouse_position().x
		sprite.scale.x = -(dir / abs(dir))
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

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and !(ui > 0):
			held = true
		else:
			held = false

func _area_entered(body) -> void:
	if body.get_groups().find("Enemy") > -1:
		enemies_on.append(body)

func _area_exited(body) -> void:
	if body.get_groups().find("Enemy") > -1 and body in enemies_on:
		enemies_on.remove_at(enemies_on.find(body))

func hurt():
	if len(enemies_on) > 0:
		damage.emit()
