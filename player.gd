extends RigidBody2D

var input = Vector2()

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	input = Input.get_vector("Left", "Right", "Up", "Down")
	print(input)
