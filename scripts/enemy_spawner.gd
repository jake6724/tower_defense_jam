# Autoloader
extends Node

var cur_wave: Array[String]
var spawn_timer: Timer = Timer.new()
var spawn_rate: float = 1.0 # Time between enemy spawn, in seconds
var can_spawn_enemy: bool = true
var active_enemies: Array[Enemy] = []

var enemies: Dictionary[String, PackedScene] = {
	"fire": preload("res://scenes/enemies/TestEnemy.tscn"),
	"water": preload("res://scenes/enemies/TestEnemy.tscn"),
	"ice": preload("res://scenes/enemies/TestEnemy.tscn"),
}

# Signals
signal wave_complete
signal all_waves_complete

# WAVE DATA
var wave_1: Array[String] = ["fire", "fire", "fire", "fire", "fire", "fire",]

func _ready():
	# Configure Wave
	cur_wave = wave_1 # this can use a queue in the future

	# Configure Timer
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	add_child(spawn_timer)

func _physics_process(_delta):
	if can_spawn_enemy and cur_wave.size() > 0:
		spawn_enemy(cur_wave.pop_front())
		
		# Restart spawn timer
		spawn_timer.start(spawn_rate)
		can_spawn_enemy = false
	
	if cur_wave.size() == 0 and active_enemies.size() == 0:
		wave_complete.emit()

func spawn_enemy(enemy_name: String):
	var new_enemy: Enemy = enemies[enemy_name].instantiate()
	new_enemy.position = GameManager.active_spawn_location
	new_enemy.is_dead.connect(on_enemy_died)
	active_enemies.append(new_enemy)
	add_child(new_enemy)

func on_enemy_died(enemy: Enemy) -> void:
	enemy.queue_free()

func on_spawn_timer_timeout():
	can_spawn_enemy = true

	
