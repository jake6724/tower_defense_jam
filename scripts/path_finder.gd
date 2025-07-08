class_name PathFinder
extends Node

# Sibling References
@export var world_grid: WorldGrid

const DIRECTIONS: Array[Vector2] = [Vector2.UP, Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN]
var a_star = AStar2D.new()

func _ready():
	initialize()

func initialize():
	add_all_points()
	connect_all_points()

## Main interface for the pathfinder. `get_path()` is a built-in...
func get_astar_path(grid_pos_a: Vector2, grid_pos_b: Vector2) -> PackedVector2Array:
	var a_id: int = get_point_id(grid_pos_a)
	var b_id: int = get_point_id(grid_pos_b)
	var a_star_path: PackedVector2Array = a_star.get_point_path(a_id, b_id)
	return a_star_path

## Configure AStar node with all world_grid grid points. AStar stores this as id + Vector2 position and uses points
## to determine pathing
func add_all_points():
	var cur_id = 0
	for grid_point in world_grid.data:
		a_star.add_point(cur_id, GameManager.grid_to_world(grid_point))
		cur_id += 1

## Iterate over all world_grid grid points and run connect_point on them. Used to connect all points to eachother in world_grid.
func connect_all_points():
	for grid_point in world_grid.data:
		connectPoint(grid_point)

func connectPoint(_point: Vector2) -> void:
	var _point_id = get_point_id(_point)		
	for direction in DIRECTIONS:
		var neighbor = _point + direction
		var neighbor_id = get_point_id(neighbor)

		if world_grid.data.has(neighbor):
			a_star.connect_points(_point_id, neighbor_id)

## Disconnect point from all of its neighbors. Requires grid_point
func disconnectPoint(grid_point: Vector2) -> void:
	var _point_id = get_point_id(grid_point)
	for direction in DIRECTIONS:
		var neighbor = grid_point + direction
		var neighbor_id = get_point_id(neighbor)
		a_star.disconnect_points(_point_id, neighbor_id)

## Takes grid point and returns AStar point ID. Requires grid point, not world point.
func get_point_id(grid_point: Vector2) -> int:
	return a_star.get_closest_point(GameManager.grid_to_world(grid_point))

func get_world_id(world_point: Vector2) -> int:
	return a_star.get_closest_point(world_point)

func get_point_id_world_position(_id: int) -> Vector2:
	return a_star.get_point_position(_id)

func get_point_id_grid_position(_id: int) -> Vector2:
	var worldPos = get_point_id_world_position(_id)
	return GameManager.world_to_grid(worldPos)
