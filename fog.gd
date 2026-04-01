extends Sprite2D

func _ready() -> void:
	visible = true
	$"../SubViewportContainer/SubViewport/revelation".visible = true
	$"../SubViewportContainer/SubViewport".reparent.call_deferred($"..")

func _process(_delta) -> void:
	material.set("shader_parameter/revealer", $"../SubViewport".get_texture())
