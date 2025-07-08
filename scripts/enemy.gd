class_name Enemy
extends Area2D

# Child references
@onready var sprite: Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D

# TODO: Could add jittering to enemy placement, so that multiple small enemies could be on 1 grid point but not all stack

var path
var min_distance: float = 1

# Enemy Stats
var health: float = 100
var speed: float = 25.0

# Signals
signal is_dead

func _ready():
	path = GameManager.active_path.duplicate() # Enemies MUST use their own local copy

## Reduce enemies `health` stat by `damage_recieved`. Return `true` if enemy died, `false` otherwise.
## Handles despawning enemy in the case of death.
func take_damage(damage_recieved: float):
	health -= damage_recieved
	if health <= 0:
		is_dead.emit(self)
		return true
	else:
		return false

func _process(delta):
	move(delta)

func move(delta) -> void:
	if path:
		if position.distance_to(path[0]) < min_distance:
			# position = path[0]
			path.remove_at(0)
		else:
			position += (path[0] - position).normalized() * speed * delta
