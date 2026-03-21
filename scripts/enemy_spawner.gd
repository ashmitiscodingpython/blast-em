extends Node2D

@onready var player = $"../Player"
@export var disabled = false
var difficulty = 1
var round_number = 1
var spawn = 5
var left = 5 # Number of enemies left to spawn
var rounded = false # Spawn enemies when true
var enemy_cooldown = 1 # Constant enemy cooldown
var time = 0
var cooldown_left = 0 # Enemy cooldown
var round_cooldown = 10 # Constant round cooldown
var deaths = 0 # Number of deaths in this round
var round_over = false
var round_cooldown_left = 0
var waiting = false
var time_over = false
var first_round = true
@warning_ignore("unused_signal")
signal death
@warning_ignore("unused_signal")
signal spawn_now

func _ready() -> void:
	if !disabled:
		$"../CanvasLayer/Round Announcer".round.emit()
		waiting = true
		time_over = false

func _process(delta: float) -> void:
	time += delta
	if !disabled:
		
		# Enemy spawn initiator
		if rounded:
			rounded = false
			spawn_enemy()
			
		# Continue spawning enemies
		if !rounded and left > 0 and !waiting:
			cooldown_left -= delta
			if cooldown_left < 0:
				spawn_enemy()
		
		# Current round is over, turn on cooldown
		if deaths == spawn and !round_over and !waiting:
			round_over = true
			$"../CanvasLayer/Round Announcer".round_end.emit()
			$"../CanvasLayer/Cooldown Bar".visible = true
			round_cooldown_left = round_cooldown
		
		# Under round cooldown
		if round_over:
			round_cooldown_left -= delta
			$"../CanvasLayer/Cooldown Bar/Health Bar".health = (round_cooldown_left / round_cooldown) * 100
			
		# Round cooldown over, initiate ROUND {NUMBER} announcement
		if round_cooldown_left < 0 and round_over:
			$"../CanvasLayer/Cooldown Bar".visible = false
			round_number += 1
			$"../CanvasLayer/Round Announcer".round.emit()
			waiting = true
			time_over = false
			round_over = false
		
		# Announcement over, initiate next round
		if waiting and time_over:
			waiting = false
			time_over = false
			rounded = true
			if !first_round:
				enemy_cooldown += 0.2
				spawn += 1
				difficulty += 0.1
				left = spawn
				deaths = 0
			else:
				first_round = false
		
func spawn_enemy():
	var enemy = load("res://scenes/enemy.tscn").instantiate()
	var rand_dir = randf_range(deg_to_rad(0), deg_to_rad(360))
	var value = Vector2(sin(rand_dir), cos(rand_dir)) * randi_range(100 - (25 * difficulty), 175 - (25 * difficulty))
	value = Vector2(
		clamp(value.x, 28, 1135),
		clamp(value.y, 91, 641)
	)
	enemy.position = player.position + value
	enemy.type = ["Slug", "Bat", "Sock", "Bear"][randi_range(0, round(difficulty) - 1)]
	get_tree().current_scene.add_child(enemy)
	cooldown_left = enemy_cooldown
	left -= 1

func on_death() -> void:
	deaths += 1

func _spawn():
	time_over = true
