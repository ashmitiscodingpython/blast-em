extends Sprite2D

@export var highlighting = false
var highlight_start = 0
var time = 0
var repeats = 75
var repeating = false
var timer_done = false
signal done

func _ready() -> void:
	visible = true
	set_instance_shader_parameter("radius", 18)

func _process(delta: float) -> void:
	time += delta
	if repeating:
		if repeats < 1:
			repeating = false
			highlighting = false
			timer_done = false
			set_instance_shader_parameter("overriding", false)
			set_instance_shader_parameter("radius", 18)
			done.emit()
		else:
			repeats -= 1
			var gettt = get_instance_shader_parameter("override")
			set_instance_shader_parameter("override", gettt + ((0 - gettt) / 5.0))
	if highlighting:
		visible = true
		var gett = get_instance_shader_parameter("radius")
		if (gett - 0.115) < 0.01:
			if !timer_done:
				timer_done = true
				$Timer.start()
		set_instance_shader_parameter("radius", gett + ((0.115 - gett) / 5))
	else:
		visible = false
		highlight_start = 0
		set_instance_shader_parameter("radius", 18)

func callback():
	repeating = true
	repeats = 75
	set_instance_shader_parameter("override", 1)
	set_instance_shader_parameter("overriding", true)
