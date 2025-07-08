class_name WaterTower
extends Tower

func set_stats() -> void:
	damage = 9
	speed = .11 # Fire rate; time between shots in seconds
	num_targets = 1 # How many enemies shot per shot max
	element = GameManager.Element.WATER