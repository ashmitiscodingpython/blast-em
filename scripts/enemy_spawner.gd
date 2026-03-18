extends Node2D

@onready var player = $"../Player"
var difficulty = 1
var round_number = 1
var spawn = 5
var left = 5
var rounded = true
var enemy_cooldown = 1
var time = 0
var cooldown_left = 0
@warning_ignore("unused_signal")
signal death

func _process(delta: float) -> void:
	time += delta
	if rounded:
		rounded = false
		spawn_enemy()
	if !rounded and left > 0:
		cooldown_left -= delta
		if cooldown_left < 0:
			spawn_enemy()

func spawn_enemy():
	var enemy = load("res://scenes/enemy.tscn").instantiate()
	var rand_dir = randf_range(deg_to_rad(0), deg_to_rad(360))
	var value = clamp(Vector2(sin(rand_dir), cos(rand_dir)) * randi_range(100 - (25 * difficulty), 175 - (25 * difficulty)), Vector2(28, 91), Vector2(1135, 641))
	enemy.position = player.position + value
	enemy.type = ["Slug", "Bat", "Sock", "Bear"][randi_range(0, difficulty - 1)]
	get_tree().current_scene.add_child(enemy)
	cooldown_left = enemy_cooldown
	left -= 1

func on_death() -> void:
	left -= 1
