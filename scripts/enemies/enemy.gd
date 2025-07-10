class_name Enemy
extends Area2D

@export var data: EnemyData

# Child references
@onready var sprite: Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var ap: AnimationPlayer = $AnimationPlayer

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

var damage: int = 10
var can_attack: bool = true

var base: Base
var is_alive: bool = true

# Signals
signal is_dead

func _ready():
	path = GameManager.active_path.duplicate() # Enemies MUST use their own local copy
	health = data.health
	speed = data.speed
	element = data.element

	set_resistances()

	base = GameManager.base
	
	ap.animation_finished.connect(on_animation_finished)
	
## Reduce enemies `health` stat by `damage_recieved`. Return `true` if enemy died, `false` otherwise.
## Handles despawning enemy in the case of death.
func take_damage(damage_recieved: float, tower_element: GameManager.Element):
	#var x = damage_recieved

	if tower_element == element or tower_element == strong_against:
		damage_recieved *= negative_modifier
	else: # Tower is strong against enemy
		damage_recieved *= positive_modifier

	health -= damage_recieved

	#print("Enemy element: ", element, " Tower element: ", tower_element, " original damage: ", x, " damage recieved: ", damage_recieved, " health: ", health)

	if health <= 0:
		die()
		return true
	else:
		return false

func _physics_process(delta):
	move(delta)

func move(delta) -> void:
	if path and is_alive:
		ap.play("idle")
		if position.distance_to(path[0]) < min_distance:
			# position = path[0]
			path.remove_at(0)
		else:
			position = (position + ((path[0] - position).normalized() * speed * delta)) # Fixed with pixel snap in project settings, but not perfect

	else:
		if can_attack:
			base.take_damage(damage)
			die()

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

func on_animation_finished(anim_name):
	if anim_name == "die":
		queue_free()

func die() -> void:
	position -= (sprite.texture.get_size() / 2)
	can_attack = false
	is_alive = false
	is_dead.emit(self)
