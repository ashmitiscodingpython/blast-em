extends CharacterBody2D

var input = Vector2()
@onready var sprite = $Sprite2D
@onready var animator = $AnimationPlayer
@onready var weapon = $weapon
@export var speed := 200
@export var accel := 1200.0
@export var friction := 1400.0
var wep = Vector2()
var input_dir

func direction(target: Vector2):
	return atan2((position.y - target.y), (position.x - target.x))

func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://kenney_desert-shooter-pack_1.0/PNG/Weapons/Tiles/tile_0035.png"))

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var target_vel = input_dir * speed
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(target_vel, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()

func _process(_delta: float) -> void:
	if input_dir.x < 0:
		sprite.scale.x = -1
	elif input_dir.x > 0:
		sprite.scale.x = 1
	if input_dir != Vector2(0, 0) and not animator.is_playing():
		animator.play("walk")
	elif input_dir == Vector2(0, 0) and animator.is_playing():
		animator.stop()
		sprite.texture = load("res://kenney_desert-shooter-pack_1.0/PNG/Players/Tiles/tile_0000.png")
	weapon.rotation = direction(get_global_mouse_position()) + deg_to_rad(180)
	if weapon.rotation_degrees < 270 and weapon.rotation_degrees > 90:
		weapon.scale.y = -1
		wep = Vector2(-11, 0)
	else:
		weapon.scale.y = 1
		wep = Vector2(11, 0)
	weapon.position += (wep - weapon.position) / 5
	weapon.rotation = direction(get_global_mouse_position()) + deg_to_rad(180)
