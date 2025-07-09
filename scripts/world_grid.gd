class_name WorldGrid
extends Node2D

var height: int = 14
var width: int = 25
var data: Dictionary[Vector2, bool] = {} # Coordinate, occupied or not

# Temp for development
var dark: PackedScene = preload("res://scenes/placeholders/grid_placeholder_dark.tscn")
var light: PackedScene = preload("res://scenes/placeholders/grid_placeholder_light.tscn")
var is_dark: bool = false
var tile_inidicator: PackedScene = preload("res://scenes/placeholders/TileIndicator.tscn")

func _ready():
	generate_grid()

func generate_grid() -> void:
	for y in range(height):
		is_dark = not is_dark # DEV
		for x in range(width):
			var grid_pos = Vector2(x,y)
			var world_pos = GameManager.grid_to_world(grid_pos)
			data[grid_pos] = true

			# # DEV
			# spawn_placeholder(world_pos)
			# is_dark = not is_dark

func spawn_placeholder(pos: Vector2) -> void:
	var p: Sprite2D
	p = tile_inidicator.instantiate()

	# if _is_dark:
	# 	p = dark.instantiate()
	# else:
	# 	p = light.instantiate()
	
	p.position = pos
	add_child(p)
