extends Sprite2D

var player: Node

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


func _process(_delta: float) -> void:
	var dx = player.position.x - position.x
	var dy = player.position.y - position.y
	var distance = sqrt(pow(dx, 2) + pow(dy, 2))
	if distance < 75:
		position += (player.position - position) / 5
	if distance < 10:
		player.get_child(1).playing = true
		player.health += 100
		player.health = clamp(player.health, 0, 500)
		queue_free()
