class_name Enemy
extends Area2D

@export var data: EnemyData

# Child references
@onready var sprite: Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D

var path
var min_distance: float = 1

# Enemy Stats from Enemy Data Resource
var health: float
var speed: float
var element: GameManager.Element

# Signals
signal is_dead

func _ready():
	path = GameManager.active_path.duplicate() # Enemies MUST use their own local copy
	health = data.health
	speed = data.speed
	element = data.element

## Reduce enemies `health` stat by `damage_recieved`. Return `true` if enemy died, `false` otherwise.
## Handles despawning enemy in the case of death.
func take_damage(damage_recieved: float, tower_element: GameManager.Element):

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
			position = (position + ((path[0] - position).normalized() * speed * delta)) # Fixed with pixel snap in project settings, but not perfect
