class_name PlayerController
extends Node2D

# Sibling References
@export var world_grid: WorldGrid

# Child References
@onready var tower_menu: TowerMenu = $UI/TowerMenu

# Scenes
var towers: Dictionary[String, PackedScene] = {
	"fire": preload("res://scenes/towers/FireTower.tscn"),
	"water": preload("res://scenes/towers/WaterTower.tscn"),
	"earth": preload("res://scenes/towers/EarthTower.tscn"),
}

var click_enabled: bool = true
var selected_tower_name: String
var gold: int = 25

func _ready():
	# Configure tower menu
	tower_menu.tower_selected.connect(on_tower_selected)
	tower_menu.mouse_entered_button.connect(on_mouse_entered_button)
	tower_menu.mouse_exited_button.connect(on_mouse_exited_button)

## Place a tower in the world grid. Return true if successful, false if not.
func spawn_tower(world_pos) -> bool:
	if selected_tower_name:
		var grid_pos: Vector2 = GameManager.world_to_grid(world_pos)
		if grid_pos in world_grid.data and world_grid.data[grid_pos]:
			var tower = towers[selected_tower_name].instantiate()
			tower.position = GameManager.grid_to_world(grid_pos) # Bring it back to world to get a clean grid point
			add_child(tower)
			# Update grid position as occupied
			world_grid.data[grid_pos] = false
			return true
		else:
			print("Invalid position or space is occupied")
			return false
	else:
		print("No tower type selected")
		return false

func _input(_event):
	# THIS IS ALL DEV
	if click_enabled and Input.is_action_just_pressed("left_click"):
		spawn_tower(get_global_mouse_position())

func on_tower_selected(tower_name: String) -> void:
	selected_tower_name = tower_name
	print(selected_tower_name)

func on_mouse_entered_button() -> void:
	click_enabled = false

func on_mouse_exited_button() -> void:
	click_enabled = true
