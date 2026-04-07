extends Area2D

var mouse = false
var paused = false

func _ready() -> void:
	$AnimationPlayer.play("Play")

func _process(_delta: float) -> void:
	if mouse:
		scale += (Vector2(3.3, 3.3) - scale) / 5
	else:
		scale += (Vector2(3, 3) - scale) / 5

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and mouse:
		if paused:
			$AnimationPlayer.play("Play")
			$"../../Player".ui -= 1
		else:
			$AnimationPlayer.play_backwards("Play")
			$"../../Player".ui += 1
		EUI.paused = !paused
		$"../../EnemySpawner".enemy_pause = !paused
		$"../../EnemySpawner".paused = !paused
		paused = !paused

func _on_mouse_entered() -> void:
	mouse = true

func _on_mouse_exited() -> void:
	mouse = false
