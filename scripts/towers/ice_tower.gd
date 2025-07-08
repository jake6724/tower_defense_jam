class_name IceTower
extends Tower

func set_stats() -> void:
	damage = 50
	speed = 1 # Fire rate; time between shots in seconds
	attack_range = 30.0 # Radius of the detection circle around tower
	num_targets = 100 # How many enemies shot per shot max
	element = "fire"