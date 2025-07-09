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
	"fire": preload("res://assets/art/sprites/spr_tower_fire.png"),
	"water": preload("res://assets/art/sprites/spr_tower_water.png"),
	"earth": preload("res://assets/art/sprites/spr_tower_earth.png"),
}

var prices: Dictionary[String, int] = {
	"fire": 25,
	"water": 75,
	"earth": 50,
}

var click_enabled: bool = true

var selected_tower_name: String
var active_towers: Array[Tower] = []
var transformed_towers: Dictionary[Tower, int] = {}
var pre_wave_towers: Array[Tower] = [] # Original configuration of towers during placement; allows transformed towers to reset 

var placement_enabled: bool = true

var gold: int = 100

var indicator_sprite: Sprite2D

func _ready():
	# Configure tower menu
	tower_menu.tower_selected.connect(on_tower_selected)
	tower_menu.mouse_entered_button.connect(on_mouse_entered_button)
	tower_menu.mouse_exited_button.connect(on_mouse_exited_button)

	tower_menu.update_gold(gold)
	tower_menu.start_wave.connect(on_start_wave)

	# Configure indicator sprite
	indicator_sprite = Sprite2D.new()
	indicator_sprite.modulate.a = .75
	indicator_sprite.centered = false
	indicator_sprite.hide()
	add_child(indicator_sprite)

	# Connect to EnemySpawner
	EnemySpawner.wave_complete.connect(on_wave_complete)

func _process(_delta):
	if selected_tower_name in towers:
		indicator_sprite.position = GameManager.grid_to_world(GameManager.world_to_grid(get_global_mouse_position()))

## Place a tower in the world grid. Return true if successful, false if not. If `is_tranform` is `true`, the gold
## cost of the tower will not be subtracted from player gold.
func spawn_tower(tower_name, world_pos, is_transform: bool=false) -> Array: # [was_spawned:bool, Tower]
	if tower_name in towers:
		var grid_pos: Vector2 = GameManager.world_to_grid(world_pos)

		if grid_pos in world_grid.data and world_grid.data[grid_pos]:
			# Spawn and configure new tower
			var tower = towers[tower_name].instantiate()
			tower.position = GameManager.grid_to_world(grid_pos) # Bring it back to world to get a clean grid point
			tower.transform_tower.connect(on_tower_transform.bind(tower))
			add_child(tower)

			# Update related data
			active_towers.append(tower)
			world_grid.data[grid_pos] = false
			if not is_transform:
				gold -= prices[tower_name]
				tower_menu.update_gold(gold)

			# Clean up indicator
			indicator_sprite.hide()

			selected_tower_name = ""
			return [true, tower]
		else:
			print("Invalid position or space is occupied")
			return [false, null]
	else:
		# print("No tower type selected")
		return [false, null]

func on_tower_selected(tower_name: String) -> void:
	# Check player can afford tower
	if gold >= prices[tower_name]:
		selected_tower_name = tower_name

		# Indicator
		indicator_sprite.texture = textures[tower_name]
		indicator_sprite.show()
		
	else:
		print("Not enough gold")

func on_tower_transform(tower: Tower) -> void:
	# Only allow transform if not previously done this combat phase AND not in placement phase
	if not placement_enabled and not transformed_towers.has(tower):
		# Remove old tower from active towers
		active_towers.remove_at(active_towers.find(tower))

		# Find what type of tower should replace it
		var next_tower_name: String = get_next_tower_name(tower)

		# Remove old tower, clear map position
		var _pos: Vector2 = tower.position
		world_grid.data[GameManager.world_to_grid(_pos)] = true
		tower.queue_free()

		# Spawn new tower, add to set
		var new_tower: Tower = spawn_tower(next_tower_name, _pos, true)[1]
		transformed_towers[new_tower] = 0
		
func get_next_tower_name(tower: Tower) -> String:
	# fire -> earth -> water -> fire
	match tower.element:
		GameManager.Element.FIRE: return "earth"
		GameManager.Element.EARTH: return "water"
		GameManager.Element.WATER: return "fire"
	return "" # Should never be reached.

func on_start_wave() -> void:
	placement_enabled = false
	copy_active_towers_to_prewave_towers()
	transformed_towers = {}
	EnemySpawner.start_wave()

	print("Start of wave")
	print("ActiveTowers: ", active_towers)
	print("PrewaveTowers: ", pre_wave_towers)

func on_wave_complete() -> void:
	if not placement_enabled:
		placement_enabled = true
		reset_towers()

func copy_active_towers_to_prewave_towers() -> void:
	for tower: Tower in active_towers:
		var copy: Tower = towers[tower.tower_name].instantiate()
		copy.position = tower.position
		pre_wave_towers.append(copy)

func reset_towers() -> void:
	print("Resetting towers")
	# Clear all active towers and replace them with towers from pre_wave_towers
	for tower: Tower in active_towers:
		tower.queue_free()
	
	for tower: Tower in pre_wave_towers:
		add_child(tower)

	active_towers = pre_wave_towers

func _input(_event):
	if click_enabled and Input.is_action_just_pressed("left_click"):
		spawn_tower(selected_tower_name, get_global_mouse_position(), false)

func on_mouse_entered_button() -> void:
	click_enabled = false

func on_mouse_exited_button() -> void:
	click_enabled = true
