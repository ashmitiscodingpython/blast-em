extends Sprite2D

var speed = 2
var time = 0
@export var bazooka = false

func _ready() -> void:
	if bazooka:
		texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Interface/Tiles/tile_0058.png")

func _process(_delta: float) -> void:
	rotation_degrees -= 90
	position += Vector2(cos(rotation) * speed, sin(rotation) * speed)
	rotation_degrees += 90
	time += _delta
	if time > 8:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.hurt.emit()
		queue_free()
