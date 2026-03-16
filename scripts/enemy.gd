extends CharacterBody2D

const speed = 250
@onready var target = $"../Player"
@onready var nav = $NavigationAgent2D
var triggerts = 0
var time = 0
signal hurt
var healthed = false
var bar
var dead = false
var death_timer = 0

func _ready() -> void:
	hurt.connect(dmg)

func _physics_process(_delta: float) -> void:
	if !dead:
		if (time - triggerts) > 0.2:
			$Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0000.png")
		time += _delta
		velocity = velocity * 0.8
		move_and_slide()

func pathi():
	nav.target_position = target.global_position

func _on_timer_timeout() -> void:
	pathi()
	
func _process(_delta: float) -> void:
	if !dead:
		if bar:
			bar.global_position = global_position - Vector2(0, 10)
	else:
		$Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0003.png")
		death_timer += _delta
		if death_timer > 2:
			queue_free()

func move() -> void:
	if !dead:
		var dir = to_local(nav.get_next_path_position()).normalized()
		velocity += speed * dir
		$Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0001.png")
		triggerts = time

func dmg():
	if !dead:
		if !healthed:
			healthed = true
			bar = load("res://scenes/health.tscn").instantiate()
			get_tree().current_scene.add_child(bar)
		bar.health -= 2
		if bar.health <= 0 and !dead:
			dead = true
			bar.queue_free()
			$Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0003.png")
		velocity = -2 * velocity
	
