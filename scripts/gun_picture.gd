extends Sprite2D

func _process(_delta: float) -> void:
	texture = load(%"Guns Info".guns[$"../../../Player".chosen_gun]["Sprite"])
	$"../Gun Name".text_ = $"../../../Player".chosen_gun
