extends CharacterBody2D

const speed = 25
@export var type = "Slug"
@onready var target = $"../Player"
@onready var nav = $NavigationAgent2D
var triggerts = 0
var time = 0
signal hurt
var healthed = false
var bar
var dead = false
var death_timer = 0
var dmg_timer = 0
var dmg_ = false

func _ready() -> void:
	hurt.connect(dmg)

func _physics_process(_delta: float) -> void:
	if !dead:
		if (time - triggerts) > 0.2 or (type != "Slug" and (time - triggerts) > 0.2):
			match type:
				"Slug": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0000.png")
				"Bat": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0004.png")
				"Sock": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0008.png")
				"Bear": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0012.png")
		time += _delta
		velocity = velocity * 0.8
		move_and_slide()

func pathi():
	nav.target_position = target.global_position

func _on_timer_timeout() -> void:
	pathi()

func on_move() -> void:
	if type == "Slug":
		move()
	
func _process(_delta: float) -> void:
	if !dead:
		if bar:
			bar.global_position = global_position - Vector2(0, 5)
		if type != "Slug":
			move()
	else:
		match type:
			"Slug": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0003.png")
			"Bat": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0007.png")
			"Sock": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0011.png")
			"Bear": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0015.png")
		death_timer += _delta
		if death_timer > 2:
			queue_free()

func move() -> void:
	if !dead:
		var dir = to_local(nav.get_next_path_position()).normalized()
		velocity += speed * dir * (10 if type == "Slug" else 1)
		if (time - triggerts) > 0.4 or type == "Slug":
			triggerts = time
			match type:
				"Slug": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0001.png")
				"Bat": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0005.png")
				"Sock": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0009.png")
				"Bear": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0013.png")

func dmg():
	if !dead:
		if !healthed:
			healthed = true
			bar = load("res://scenes/health.tscn").instantiate()
			bar.enemish = true
			bar.health = 100
			add_child(bar)
			bar.scale = Vector2(0.5, 0.5)
		match type:
			"Slug": bar.health -= 10
			"Bear": bar.health -= 0.5
			"Bat": bar.health -= 4
			"Sock": bar.health -= 3
		if bar.health <= 0 and !dead:
			$"../EnemySpawner".death.emit()
			$CollisionShape2D.queue_free()
			var star = load("res://scenes/star.tscn").instantiate()
			star.global_position = global_position
			get_tree().current_scene.add_child(star)
			dead = true
			bar.queue_free()
			match type:
				"Slug": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0003.png")
				"Bat": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0007.png")
				"Sock": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0011.png")
				"Bear": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0015.png")
		velocity = -2 * velocity
	
