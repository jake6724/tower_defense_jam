class_name PlayerController
extends Node2D

# Sibling References
@export var world_grid: WorldGrid
@export var pathfinder: PathFinder

var tower: PackedScene = preload("res://scenes/towers/FireTower.tscn") # Need to allow for different types of towers 

# DEV
@export_group("DEVELOPMENT")
@export var enemy: Enemy
var to
var from
var prev_line: Line2D

## Place a tower in the world grid. Return true if successful, false if not.
func spawn_tower(world_pos) -> bool:
	var grid_pos: Vector2 = GameManager.world_to_grid(world_pos)

	if grid_pos in world_grid.data and world_grid.data[grid_pos]:
		var t = tower.instantiate()
		t.position = GameManager.grid_to_world(grid_pos) # Bring it back to world to get a clean grid point
		add_child(t)
		# Update grid position as occupied
		world_grid.data[grid_pos] = false
		return true
	else:
		print("Invalid position or space is occupied")
		return false

func _input(_event):
	# THIS IS ALL DEV
	if Input.is_action_just_pressed("left_click"):
		spawn_tower(get_global_mouse_position())

	if Input.is_action_just_pressed("right_click"):
		if from:
			to = get_global_mouse_position()
			var path = pathfinder.get_astar_path(GameManager.world_to_grid(from), GameManager.world_to_grid(to))
			enemy.path = path
			print(path)

			if prev_line:
				prev_line.queue_free()

			var line: Line2D = Line2D.new()
			line.default_color = Color.RED
			line.points = path
			add_child(line)

			prev_line = line

			from = null

		else:
			from = get_global_mouse_position()
