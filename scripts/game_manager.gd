# Autoloader
extends Node

var cell_size: int = 16
var active_path: PackedVector2Array
var active_spawn_location: Vector2 # In world coordinates

var levels: Array[PackedScene] = [preload("res://scenes/level/LevelEnvironmentOne.tscn")]
var active_level: LevelEnvironment

var path_1
var path_1_spawn_location: Vector2 = Vector2(0,9)

enum Element {FIRE, WATER, EARTH}

func _ready():
	active_level = levels[0].instantiate()
	add_child(active_level)
	active_path = convert_path_to_world((active_level.waypoint_manager.get_waypoint_path()))
	active_spawn_location = (active_path[0])

	# Configure Enemy Spawner
	EnemySpawner.all_waves = active_level.waves

func convert_path_to_world(path) -> PackedVector2Array:
	for i in range(path.size()):
		path[i] = GameManager.grid_to_world(path[i])
	return path

func grid_to_world(_pos: Vector2) -> Vector2:
	return _pos * cell_size

func world_to_grid(_pos: Vector2) -> Vector2:
	return floor(_pos / cell_size)
