extends CharacterBody2D

const speed = 25
@export var type = "Slug"
@onready var target = $"../Player"
@onready var nav = $NavigationAgent2D
@onready var player_: playerscript
var triggerts = 0
var time = 0
signal hurt
var healthed = false
var bar
var dead = false
var death_timer = 0
var dmg_timer = 0
var dmg_ = false
var health = 0
var total_health = 0

func _ready() -> void:
	player_ = get_tree().get_first_node_in_group("Player")
	hurt.connect(dmg)
	player_.damage.connect(player_dmg)
	match type:
		"Bear": total_health = 200
		"Slug": total_health = 25
		"Bat": total_health = 24
		"Sock": total_health = 34
	health = total_health
	if type == "Bat":
		collision_layer = 8388608
		collision_mask = 2

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
	bar.health = (float(health) / float(total_health)) * 100
	if player_.position.x > position.x:
		$Enemy.scale.x = 1
	else:
		$Enemy.scale.x = -1
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
		health -= 1
		if bar.health <= 0 and !dead:
			$"../EnemySpawner".death.emit()
			$CollisionShape2D.queue_free()
			if randi_range(0, 100) > 25:
				var star = load("res://scenes/star.tscn").instantiate()
				star.global_position = global_position
				get_tree().current_scene.add_child(star)
			dead = true
			bar.queue_free()
			$Death.emitting = true
			match type:
				"Slug": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0003.png")
				"Bat": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0007.png")
				"Sock": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0011.png")
				"Bear": $Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0015.png")
		velocity = -2 * velocity

func player_dmg():
	if $"." in player_.enemies_on:
		for child in player_.get_children():
			if child.name == "HurtSound":
				child.playing = true
		match type:
			"Slug": player_.health -= 3
			"Bat": player_.health -= 2
			"Sock": player_.health -= 1
			"Bear": player_.health -= 4
