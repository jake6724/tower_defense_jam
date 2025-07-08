class_name WaterTower
extends Tower

func set_stats() -> void:
	damage = 100
	speed = .66 # Fire rate; time between shots in seconds
	num_targets = 1 # How many enemies shot per shot max
	element = "water"