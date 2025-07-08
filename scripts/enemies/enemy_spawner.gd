# Autoloader
extends Node

var active_wave: Array[GameManager.Element]
var spawn_timer: Timer = Timer.new()
var spawn_rate: float = 1.0 # Time between enemy spawn, in seconds
var can_spawn_enemy: bool = true
var active_enemies: Array[Enemy] = []

var enemies: Dictionary[GameManager.Element, PackedScene] = {
	GameManager.Element.FIRE: preload("res://scenes/enemies/FireEnemy.tscn"),
	GameManager.Element.WATER: preload("res://scenes/enemies/WaterEnemy.tscn"),
	GameManager.Element.EARTH: preload("res://scenes/enemies/EarthEnemy.tscn"),
}

# Signals
signal wave_complete
signal all_waves_complete

#### NOTE ENEMY SPAWNER PARTIALLY CONFIGURED IN GAME MANAGER ####
func _ready():
	# Configure Timer
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	add_child(spawn_timer)

func _physics_process(_delta):
	if can_spawn_enemy and active_wave.size() > 0:
		spawn_enemy(active_wave.pop_front())
		
		# Restart spawn timer
		spawn_timer.start(spawn_rate)
		can_spawn_enemy = false
	
	if active_wave.size() == 0 and active_enemies.size() == 0:
		wave_complete.emit()

func spawn_enemy(enemy_type: GameManager.Element):
	var new_enemy: Enemy = enemies[enemy_type].instantiate()
	new_enemy.position = GameManager.active_spawn_location
	new_enemy.is_dead.connect(on_enemy_died)
	active_enemies.append(new_enemy)
	add_child(new_enemy)

func on_enemy_died(enemy: Enemy) -> void:
	active_enemies.remove_at(active_enemies.find(enemy))
	enemy.queue_free()

func on_spawn_timer_timeout():
	can_spawn_enemy = true
