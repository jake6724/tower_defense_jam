# Autoloader
extends Node

enum Element {FIRE, WATER, EARTH}
var cell_size: int = 16

var levels: Array[PackedScene] = [preload("res://scenes/level/LevelEnvironmentTutorial.tscn"), preload("res://scenes/level/LevelEnvironmentOne.tscn")]
var level_index: int = 0
var active_level: LevelEnvironment
var active_path: PackedVector2Array
var active_spawn_location: Vector2 # In world coordinates

var base: Base

var wave_count: int = 1

func _ready():
	configure_level()

func configure_level():
	active_level = levels[level_index].instantiate()
	add_child(active_level)
	active_path = convert_path_to_world((active_level.waypoint_manager.get_waypoint_path()))
	active_spawn_location = (active_path[0])

	base = active_level.base
	base.was_destroyed.connect(on_base_was_destroyed)

	# Configure WorldGrid
	WorldGrid.generate_grid()
	WorldGrid.configure_tilemap(active_level.tilemap)
	
	# Configure EnemySpawner
	EnemySpawner.all_waves = active_level.waves
	EnemySpawner.wave_complete.connect(on_wave_complete)

func on_base_was_destroyed():
	configure_level()

func on_wave_complete():
	wave_count += 1

func convert_path_to_world(path) -> PackedVector2Array:
	for i in range(path.size()):
		path[i] = GameManager.grid_to_world(path[i])
	return path

func grid_to_world(_pos: Vector2) -> Vector2:
	return _pos * cell_size

func world_to_grid(_pos: Vector2) -> Vector2:
	return floor(_pos / cell_size)
