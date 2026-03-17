extends Node2D

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
	enemy.position = Vector2(randi_range(22, 1143), randi_range(83, 648))
	enemy.type = ["Slug", "Bat", "Sock", "Bear"][randi_range(0, difficulty - 1)]
	get_tree().current_scene.add_child(enemy)
	cooldown_left = enemy_cooldown
	left -= 1

func on_death() -> void:
	left -= 1
