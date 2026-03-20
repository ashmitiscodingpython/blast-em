extends Node2D

@export var constant := false
@export var text_position: Vector2
@export var text_: String
@export var align_ := "left"
@export var scale_: float

@export_group("Continuous Types")
@export var coins = false
@export var round_announcer = false

@warning_ignore("unused_signal")
signal round
var rounding = false
var repeats = 200
var cursize = 32

const letters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

@onready var mapping = [
	fro_to(93, 102, 4),
	fro_to(108, 120, 4),
	fro_to(126, 138, 4)
]

func index(letter: String):
	letter = letter.to_upper()
	var li = letters.find(letter) + 1
	if li < 11:
		return [1, li]
	elif li < 24:
		return [2, li - 10]
	else:
		return [3, li - 23]

func fro_to(from, to, filler):
	var list = []
	for i in range(from, to + 1):
		var result = ""
		result += str(i)
		if len(result) < filler:
			for j in range(filler - len(str(i))):
				result = "0" + result
		list.append(result)
	return list

func get_path_(letter):
	var ind = index(letter)
	var num = mapping[ind[0] - 1][ind[1] - 1]
	return "res://kenney_desert-shooter-pack_1.0/PNG/Interface/Tiles/tile_{0}.png".format({0: num})

@warning_ignore("unused_parameter")
func write(text: String, coords: Vector2, align: String, scaled: float):
	if get_children():
		for child in get_children():
			child.queue_free()
	var length = len(text) * (16 * (scaled / 1.5))
	var minus = 0
	if align.to_lower() == "center":
		minus = 0.5
	elif align.to_lower() == "right":
		minus = 1
	coords.x -= (length * minus)
	var now = coords
	for letter in text:
		if letter != " ":
			var one = Sprite2D.new()
			one.texture = load(get_path_(letter))
			one.global_position = now
			one.scale = Vector2(scaled, scaled)
			one.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			add_child(one)
		now.x += 16 * (scaled / 1.5)

func _ready() -> void:
	if constant:
		write(text_, text_position, align_, scale_)

func _process(_delta: float) -> void:
	if !constant:
		if coins:
			write(str($"../../Player".coins), Vector2(50, -25), "left", 3)
		if round_announcer:
			if rounding and repeats > 0:
				repeats -= 1
				print(repeats)
				write("round " + str($"../../EnemySpawner".round_number), text_position, align_, cursize)
				cursize += (4.0 - cursize) / 5
			if repeats == 0:
				for child in get_children():
					child.queue_free()
				rounding = false
				$"../../EnemySpawner".spawn_now.emit()

func roundup():
	repeats = 200
	cursize = 32
	rounding = true
