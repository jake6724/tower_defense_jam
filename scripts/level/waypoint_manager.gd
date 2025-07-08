class_name WaypointManager
extends Node2D

var waypoint_path: Array[Vector2]

func _ready():
	for child in get_children():
		waypoint_path.append(GameManager.world_to_grid(child.position)) # Does world to grid because that is the original implementation for manually entered paths
	
	GameManager.path_1 = waypoint_path