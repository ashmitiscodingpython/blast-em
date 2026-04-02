extends Node2D

# Recoil, Firepower, Damage, Reload, Knockback, Explosiveness, Bazooka, Accuracy
# [0, 1, 3, 1, 3, 0, false]

func rating(ratings: Array[float], bazooka: bool, path: String):
	var recoil = lerp(0, 25, ratings[0] / 10)
	var firepower = lerp(1, 25, ratings[1] / 10)
	var damage = lerp(1, 8, ratings[2] / 10)
	var reload = lerp(1.0, 0.1, ratings[3] / 10)
	var knockback = lerp(0, 30, ratings[4] / 10)
	var accuracy = lerp(25, 0, ratings[5] / 10)
	return {
		"Recoil": recoil,
		"Firepower": firepower,
		"Damage": damage,
		"Reload": reload,
		"Knockback": knockback,
		"Accuracy": accuracy,
		"Bazooka": bazooka,
		"Sprite": path
	}

var guns = {
	"Pistol": rating([1, 5, 5, 7, 3, 7], false, "res://kenney_desert-shooter-pack_1.0/PNG/Weapons/Tiles/tile_0002.png"),
	"SMG": rating([3, 6, 2, 10, 1, 1], false, "res://kenney_desert-shooter-pack_1.0/PNG/Weapons/Tiles/tile_0004.png"),
	"Shotgun": rating([9, 4, 9, 3, 9, 2], false, "res://kenney_desert-shooter-pack_1.0/PNG/Weapons/Tiles/tile_0006.png"),
	"Rifle": rating([5, 7, 7, 5, 5, 8], false, "res://kenney_desert-shooter-pack_1.0/PNG/Weapons/Tiles/tile_0007.png"),
	"Sniper": rating([10, 10, 10, 2, 8, 10], false, "res://kenney_desert-shooter-pack_1.0/PNG/Weapons/Tiles/tile_0003.png"),
	"Bazooka": rating([10, 2, 10, 4, 10, 5], true, "res://kenney_desert-shooter-pack_1.0/PNG/Weapons/Tiles/tile_0013.png")
}

var current_gun = "Pistol"
var current_details = {}
var gun_names = ["Pistol", "SMG", "Shotgun", "Rifle", "Bazooka", "Sniper"]

func _process(_delta: float) -> void:
	current_details = guns[current_gun]
