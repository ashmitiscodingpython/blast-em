extends Node2D

@export var size = Vector2(0, 0)
@export var closed_position = Vector2(576, 800)
@export var open_position: Vector2
@export var process = true
@export var open = false
@export var button = false
@export var text_included = false
@export var auto_set_open_position = true
@export var close_button = true

@export_group("Text")
@export var text: String
@export var constant = true
@export var relative_position = Vector2(0, 0)
@export var align = "center"
@export var scale_ = 1.0

@export_group("Button Actions")
@export var button_scale = 1.2
@export var fade_when_closed = false
@export var upgrade = false
@export var done = false
@export var crate = false
@export var guns_confirm = false
@export var guns_reroll = false

var mouse = false
var player
var mouse_whole = false
var totalable = 0
var orig_scale
var hidden_chosen
var rolls_left = 0
var cooldown = 0

func set_children_modulate():
	for child in get_children():
		child.modulate = modulate

func _ready() -> void:
	orig_scale = scale
	player = get_tree().get_first_node_in_group("Player")
	if text_included:
		var texty = Node2D.new()
		texty.set_script(load("res://scripts/number.gd"))
		texty.constant = true
		texty.text_position = relative_position
		texty.align_ = align
		texty.scale_ = scale_
		texty.text_ = text
		add_child.call_deferred(texty)
	if !close_button:
		$"Close".queue_free()
	if !open:
		visible = false
	if auto_set_open_position:
		open_position = position
	if button:
		$Collider/CollisionShape2D.shape.size = size + Vector2(48, 48)

func _process(_delta: float) -> void:
	var cond = (closed_position.x - position.x < 1) and (closed_position.y - position.y < 1)
	if button and guns_reroll:
		if cooldown > 0:
			cooldown -= _delta
		if rolls_left > 0 and cooldown <= 0:
			rolls_left -= 1
			player.chosen_gun = $"../../../Guns Info".gun_names[rolls_left % 6]
			cooldown = pow(((50 - rolls_left) / 49.0), 5)
			if rolls_left == 0:
				$"../Burst".emitting = true
	if button and upgrade:
		if player.coins < 1:
			mouse_whole = false
			modulate = Color(0.7, 0.7, 0.7, 1)
		else:
			modulate = Color(1, 1, 1, 1)
	if mouse_whole and button:
		scale += ((orig_scale * button_scale) - scale) / 5
	elif button:
		scale += ((orig_scale) - scale) / 5
	if !open and cond:
		visible = true
	if open and process:
		if fade_when_closed:
			var to_transition = Color(1, 1, 1, 1)
			var result = Color(
				to_transition.r - modulate.r,
				to_transition.g - modulate.g,
				to_transition.b - modulate.b,
				to_transition.a - modulate.a
			)
			modulate += result / 5
		position += (open_position - position) / 5
	elif process:
		if fade_when_closed:
			var to_transition = Color(1, 1, 1, 0)
			var result = Color(
				to_transition.r - modulate.r,
				to_transition.g - modulate.g,
				to_transition.b - modulate.b,
				to_transition.a - modulate.a
			)
			modulate += result / 5
		position += (closed_position - position) / 5
	if process:
		if close_button:
			if mouse:
				$Close/Sprite.scale += (Vector2(1.2, 1.2) - $Close/Sprite.scale) / 5
			else:
				$Close/Sprite.scale += (Vector2(0.85, 0.85) - $Close/Sprite.scale) / 5
		$Center.size.x = size.x + 18
		$Center.size.y = size.y + 18
		$Center.position = Vector2(
			-9 - (size.x / 2),
			-9 - (size.y / 2)
		)
		$"Bottom Edge".size.x = size.x + 16
		$"Bottom Edge".position = Vector2(-8 - (size.x / 2.0), 8 + (size.y / 2.0))
		$"Top Edge".size.x = size.x + 16
		$"Top Edge".position = Vector2(-8 - (size.x / 2.0), -24 - (size.y / 2.0))
		$"Left Edge".size.y = 16 + size.y
		$"Left Edge".position = Vector2(-24 - (size.x / 2.0), -8 - (size.y / 2.0))
		$"Right Edge".size.y = 16 + size.y
		$"Right Edge".position = Vector2(8 + (size.x / 2.0), -8 - (size.y / 2.0))
		$"Bottom Right".position = Vector2(16 + (size.x / 2.0), 16 + (size.y / 2.0))
		$"Bottom Left".position = Vector2(-16 - (size.x / 2.0), 16 + (size.y / 2.0))
		$"Top Right".position = Vector2(16 + (size.x / 2.0), -16 - (size.y / 2.0))
		$"Top Left".position = Vector2(-16 - (size.x / 2.0), -16 - (size.y / 2.0))

func _mouse() -> void:
	if !mouse:
		player.ui += 1
	mouse = true

func _mouse_left() -> void:
	if mouse:
		player.ui -= 1
	mouse = false

func mouse_on() -> void:
	if button:
		if not mouse_whole:
			player.ui += 1
		mouse_whole = true

func mouse_off() -> void:
	if button:
		if mouse_whole:
			player.ui -= 1
		mouse_whole = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if mouse:
			open = !open
		if mouse_whole and button and guns_confirm:
			$"../../../Guns Info".current_gun = player.chosen_gun
			$"..".open = false
		if mouse_whole and button and guns_reroll:
			hidden_chosen = $"../../../Guns Info".gun_names.pick_random()
			rolls_left = 50
		if mouse_whole and button and upgrade:
			if $"../../Cooldown Bar".visible:
				$"../../Cooldown Bar".visible = false
				$"../../../EnemySpawner".paused = true
			$"..".open = false
			$"../../Selection Done".visible = true
			if player.keys > 0:
				$"../../Selection Visibilty Controller".positions = Vector2(73, 239)
				$"../../Selection Visibilty Controller".set_posses()
			$"../../Selection Visibilty Controller".visible = true
			player.coins -= 1
			if totalable == 0:
				$"../../../Selection Layer".selected_total = 0
				player.ui += 1
			totalable += 25
			$"../../../Selection Layer".selecting = true
		if mouse_whole and button and done:
			var selection = $"../../Selection Layer"
			$"../Selection Visibilty Controller".visible = false
			if $"../../EnemySpawner".paused:
				$"../Cooldown Bar".visible = true
				$"../../EnemySpawner".paused = false
			player.ui -= 1
			$"../Upgrade Menu/Upgrade Button".totalable = 0
			visible = false
			selection.selected_total = 0
			selection.selecting = false
			for pos in selection.ons:
				if selection.ons[pos]:
					$"../../SubViewport/revelation".erase_cell(pos)
					$"../../Fog Collision".erase_cell(pos)
					selection.ons[pos] = false
			selection.update_cells()
		if mouse_whole and button and crate:
			player.chosen_gun = $"../../Guns Info".gun_names.pick_random()
