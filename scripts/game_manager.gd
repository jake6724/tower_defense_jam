# Autoloader
extends Node

enum Element {FIRE, WATER, EARTH}
var cell_size: int = 16

var main_scene: PackedScene = preload("res://scenes/Main.tscn")
var main: Node2D

var level_zero: PackedScene = preload("res://scenes/level/LevelEnvironmentTutorial.tscn")

var levels: Array[PackedScene] = [level_zero, preload("res://scenes/level/LevelEnvironmentTutorial.tscn"), preload("res://scenes/level/LevelEnvironmentOne.tscn")]
var level_index: int = 0
var active_level: LevelEnvironment
var active_path: PackedVector2Array
var active_spawn_location: Vector2 # In world coordinates

var base: Base

func _ready():
	EnemySpawner.level_complete.connect(on_level_complete)
	configure_level()

func configure_level():
	active_level = levels[level_index].instantiate()
	add_child(active_level)
	active_path = convert_path_to_world((active_level.waypoint_manager.get_waypoint_path()))
	active_spawn_location = (active_path[0])

	base = active_level.base
	base.base_destroyed.connect(on_base_destroyed)

	# Configure Autoloaders
	WorldGrid.generate_grid()
	WorldGrid.configure_tilemap(active_level.tilemap)

	EnemySpawner.configure_level(active_level)

func on_base_destroyed():
	# Reset Main Scene
	get_tree().change_scene_to_packed(main_scene)

	# Re-configure autoloaders
	clear_level()
	configure_level()

func clear_level():
	active_level.queue_free()
	active_level = null
	active_path = []
	active_spawn_location = Vector2()

	base.base_destroyed.disconnect(on_base_destroyed)
	base = null

	EnemySpawner.clear_level()

func on_level_complete(): # Emitted by EnemySpawner
	level_index += 1
	on_base_destroyed()

func convert_path_to_world(path) -> PackedVector2Array:
	for i in range(path.size()):
		path[i] = GameManager.grid_to_world(path[i])
	return path

func grid_to_world(_pos: Vector2) -> Vector2:
	return _pos * cell_size

func world_to_grid(_pos: Vector2) -> Vector2:
	return floor(_pos / cell_size)
