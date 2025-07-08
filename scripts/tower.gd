class_name Tower
extends Node2D

# Child references
@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var collider: CollisionShape2D = $Area2D/CollisionShape2D

var active_targets: Array[Enemy] = []
var inactive_targets: Array[Enemy] = []
var attack_timer: Timer

# Tower stats
var damage: float = 5
var speed: float = 1 # Fire rate; time between shots in seconds
var num_targets: int = 1 # How many enemies shot per shot max

var can_attack: bool = true

func _ready():
	# Configure Area2D
	area.area_entered.connect(on_area_entered)
	area.area_exited.connect(on_area_exited)

	# Configure Timer
	attack_timer.timeout.connect(on_attack_timer_timeout)
	add_child(attack_timer)

func _physics_process(_delta):
	if can_attack:
		attack()

func attack() -> void:
	for enemy in active_targets:
		var is_dead: bool = enemy.take_damage(damage) # TODO: Enemy interface for this needed
		if is_dead:
			active_targets.remove_at(active_targets.find(enemy))
			update_active_targets()

	# Restart attack timer
	can_attack = false
	attack_timer.start(speed)

func on_area_entered(intruder: Area2D) -> void:
	if intruder is Enemy:
		inactive_targets.append(intruder)
		update_active_targets()

func on_area_exited(intruder) -> void:
	if intruder is Enemy:
		if intruder in active_targets:
			active_targets.remove_at(active_targets.find(intruder))
			update_active_targets()

		elif intruder in inactive_targets:
			inactive_targets.remove_at(inactive_targets.find(intruder))

func update_active_targets() -> void:
	# Move as many inactive targets to active as possible/allowed
	while active_targets.size() < num_targets and inactive_targets[0]:
		active_targets.append(inactive_targets.pop_front())

func on_attack_timer_timeout() -> void:
	can_attack = true