class_name Enemy
extends Area2D

@export var data: EnemyData

# Child references
@onready var sprite: Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D

var path: PackedVector2Array
var min_distance: float = 1

# Enemy Stats from Enemy Data Resource
var health: float
var speed: float
var element: GameManager.Element
var weak_against: GameManager.Element
var strong_against: GameManager.Element

var negative_modifier: float = .5
var positive_modifier: float = 2.0

var attack_timer: Timer = Timer.new()
var attack_speed: float = .5 # Time between attacks
var damage: int = 1
var can_attack: bool = true

var base: Base

# Signals
signal is_dead

func _ready():
	path = GameManager.active_path.duplicate() # Enemies MUST use their own local copy
	health = data.health
	speed = data.speed
	element = data.element

	set_resistances()

	add_child(attack_timer)
	attack_timer.one_shot = true
	attack_timer.timeout.connect(on_attack_timer_timeout)

	# Get reference to player base
	base = GameManager.base
	print(base)
	
## Reduce enemies `health` stat by `damage_recieved`. Return `true` if enemy died, `false` otherwise.
## Handles despawning enemy in the case of death.
func take_damage(damage_recieved: float, tower_element: GameManager.Element):
	var x = damage_recieved

	if tower_element == element or tower_element == strong_against:
		damage_recieved *= negative_modifier
	else: # Tower is strong against enemy
		damage_recieved *= positive_modifier

	health -= damage_recieved

	print("Enemy element: ", element, " Tower element: ", tower_element, " original damage: ", x, " damage recieved: ", damage_recieved, " health: ", health)

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

	else:
		if can_attack:
			base.take_damage(damage)
			can_attack = false
			attack_timer.start(attack_speed)

func on_attack_timer_timeout() -> void:
	can_attack = true

func set_resistances() -> void:
	match element:
		GameManager.Element.FIRE: 
			strong_against = GameManager.Element.EARTH
			weak_against = GameManager.Element.WATER

		GameManager.Element.EARTH:
			strong_against = GameManager.Element.WATER
			weak_against = GameManager.Element.FIRE

		GameManager.Element.WATER:
			strong_against = GameManager.Element.FIRE
			weak_against = GameManager.Element.EARTH
