# Autoloader
extends Node

var cur_wave: Array[String] = wave_1
var spawn_timer: Timer = Timer.new()
var spawn_rate: float = 1.0 # Time between enemy spawn, in seconds
var can_spawn_enemy: bool = true

var enemies: Dictionary[String, PackedScene] = {
	"fire": preload("res://scenes/enemies/TestEnemy.tscn"),
	"water": preload("res://scenes/enemies/TestEnemy.tscn"),
	"ice": preload("res://scenes/enemies/TestEnemy.tscn"),
}

# WAVE DATA
var wave_1: Array[String] = ["fire", "fire", "fire", "fire", "fire", "fire"]

func _ready():
	# Configure Timer
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	add_child(spawn_timer)

func _physics_process(_delta):
	if can_spawn_enemy and cur_wave.size() > 0:
		spawn_enemy(cur_wave.pop_front())
		
		# Restart spawn timer
		spawn_timer.start(spawn_rate)
		can_spawn_enemy = false

func spawn_enemy(enemy_name: String):
	var new_enemy: Enemy = enemies[enemy_name].instantiate()
	new_enemy.position = GameManager.active_spawn_location
	add_child(new_enemy)

func on_spawn_timer_timeout():
	can_spawn_enemy = true

	
