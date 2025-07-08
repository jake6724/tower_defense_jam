# Autoloader
extends Node

var cell_size: int = 16
var active_path: PackedVector2Array
var active_spawn_location: Vector2 # In world coordinates

# LEVEL PATHS
var path_1: PackedVector2Array = [Vector2(0,9), Vector2(1,9), Vector2(2,9), Vector2(3,9), Vector2(4,9), Vector2(5,9), 
Vector2(5,8), Vector2(5,7), Vector2(6,7), Vector2(7,7), Vector2(8,7), Vector2(9,7), Vector2(9, 8), Vector2(9, 9), 
Vector2(9, 10), Vector2(9,11), Vector2(10,11), Vector2(11,11), Vector2(12,11), Vector2(13,11),Vector2(14,11),Vector2(15,11),
Vector2(15,10),Vector2(15,9)]
var path_1_spawn_location: Vector2 = Vector2(0,9)

func _ready():
	active_path = convert_path_to_world(path_1)
	active_spawn_location = grid_to_world(path_1_spawn_location)

func convert_path_to_world(path) -> PackedVector2Array:
	for i in range(path.size()):
		print("Before: ", path[i])
		path[i] = GameManager.grid_to_world(path[i])
		print("After: ", path[i])

	print("Converted Path: ", path)
	return path

func grid_to_world(_pos: Vector2) -> Vector2:
	return _pos * cell_size

func world_to_grid(_pos: Vector2) -> Vector2:
	return floor(_pos / cell_size)
