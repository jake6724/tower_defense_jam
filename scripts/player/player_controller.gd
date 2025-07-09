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

var textures: Dictionary[String, Texture] = {
	"fire": preload("res://assets/art/sprites/spr_enemy_fire.png"),
	"water": preload("res://assets/art/sprites/spr_tower_water.png"),
	"earth": preload("res://assets/art/sprites/spr_tower_earth.png"),
}

var prices: Dictionary[String, int] = {
	"fire": 25,
	"water": 50,
	"earth": 75,
}

var click_enabled: bool = true
var selected_tower_name: String
var gold: int = 100

var indicator_sprite: Sprite2D

func _ready():
	# Configure tower menu
	tower_menu.tower_selected.connect(on_tower_selected)
	tower_menu.mouse_entered_button.connect(on_mouse_entered_button)
	tower_menu.mouse_exited_button.connect(on_mouse_exited_button)

	# Configure indicator sprite
	indicator_sprite = Sprite2D.new()
	indicator_sprite.modulate.a = .75
	indicator_sprite.hide()
	add_child(indicator_sprite)

## Place a tower in the world grid. Return true if successful, false if not.
func spawn_tower(world_pos) -> bool:
	if selected_tower_name in towers:
		var grid_pos: Vector2 = GameManager.world_to_grid(world_pos)
		if grid_pos in world_grid.data and world_grid.data[grid_pos]:
			# Spawn
			var tower = towers[selected_tower_name].instantiate()
			tower.position = GameManager.grid_to_world(grid_pos) # Bring it back to world to get a clean grid point
			add_child(tower)

			# Update data
			world_grid.data[grid_pos] = false
			selected_tower_name = ""

			# Clean up indicator
			indicator_sprite.hide()

			return true
		else:
			print("Invalid position or space is occupied")
			return false
	else:
		print("No tower type selected")
		return false

func _process(delta):
	if selected_tower_name in towers:
		indicator_sprite.position = get_global_mouse_position()

func _input(_event):
	# THIS IS ALL DEV
	if click_enabled and Input.is_action_just_pressed("left_click"):
		spawn_tower(get_global_mouse_position())

func on_tower_selected(tower_name: String) -> void:
	# Check player can afford tower
	if gold >= prices[tower_name]:
		selected_tower_name = tower_name
		print(selected_tower_name)

		# Indicator
		indicator_sprite.texture = textures[tower_name]
		indicator_sprite.show()
		print(selected_tower_name)
	else:
		print("Not enough gold")

func on_mouse_entered_button() -> void:
	click_enabled = false

func on_mouse_exited_button() -> void:
	click_enabled = true
