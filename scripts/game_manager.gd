# Autoloader
extends Node

enum Element {FIRE, WATER, EARTH}
var cell_size: int = 16

var main_scene: PackedScene = preload("res://scenes/Main.tscn")
var main: Node2D

var level_zero: PackedScene = preload("res://scenes/level/LevelEnvironmentZero.tscn")
var level_tutorial: PackedScene = preload("res://scenes/level/LevelEnvironmentTutorial.tscn")
var level_one: PackedScene = preload("res://scenes/level/LevelEnvironmentOne.tscn")

var levels: Array[PackedScene] = [level_zero, level_tutorial, level_one]
var level_index: int = 1
var active_level: LevelEnvironment
var active_path: PackedVector2Array
var active_spawn_location: Vector2 # In world coordinates

var base: Base

var level_complete_timer: Timer = Timer.new()
var level_complete_duration: float = 2

func _ready():
	# configure_level() called in main - level only configured when main is ready to parent it
	EnemySpawner.level_complete.connect(on_level_complete)

	level_complete_timer.one_shot = true
	level_complete_timer.autostart = false
	level_complete_timer.timeout.connect(on_level_complete_message_finished)
	add_child(level_complete_timer)

func configure_active_level():
	active_level = levels[level_index].instantiate()

func configure_level():
	main = get_tree().root.get_node("Main")
	main.add_child(active_level)
	active_path = convert_path_to_world((active_level.waypoint_manager.get_waypoint_path()))
	active_spawn_location = (active_path[0])

	base = active_level.base
	base.base_destroyed.connect(start_level)

	# Configure Autoloaders
	WorldGrid.generate_grid()
	WorldGrid.configure_tilemap(active_level.tilemap)
	EnemySpawner.configure_level(active_level)

func start_level():
	# Reset autoloaders
	clear_level()

	# Instantiate a new level scene - will become a child of Main
	active_level = levels[level_index].instantiate()

	# Reset Main Scene - this will trigger configure_level()
	get_tree().change_scene_to_packed(main_scene)

func clear_level():
	active_level = null
	active_path = []
	active_spawn_location = Vector2()
	base.base_destroyed.disconnect(start_level)
	base = null
	EnemySpawner.clear_level()

func on_level_complete(): # Emitted by EnemySpawner
	main.round_info.show_level_complete()
	level_complete_timer.start(level_complete_duration)

func on_level_complete_message_finished():
	level_index += 1
	start_level()

func convert_path_to_world(path) -> PackedVector2Array:
	for i in range(path.size()):
		path[i] = GameManager.grid_to_world(path[i])
	return path

func grid_to_world(_pos: Vector2) -> Vector2:
	return _pos * cell_size

func world_to_grid(_pos: Vector2) -> Vector2:
	return floor(_pos / cell_size)
