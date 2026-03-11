extends CharacterBody2D

const speed = 250
@onready var target = $"../Player"
@onready var nav = $NavigationAgent2D
var triggerts = 0
var time = 0

func _physics_process(_delta: float) -> void:
	if (time - triggerts) > 0.2:
		$Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0000.png")
	time += _delta
	velocity = velocity * 0.8
	move_and_slide()

func pathi():
	nav.target_position = target.global_position

func _on_timer_timeout() -> void:
	pathi()

func move() -> void:
	var dir = to_local(nav.get_next_path_position()).normalized()
	velocity += speed * dir
	$Enemy.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Enemies/Tiles/tile_0001.png")
	triggerts = time
