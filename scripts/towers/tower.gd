class_name Tower
extends Node2D

# Child references
@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var collider: CollisionShape2D = $Area2D/CollisionShape2D

var active_targets: Array[Enemy] = []
var inactive_targets: Array[Enemy] = []
var attack_timer: Timer = Timer.new()

# Tower stats
var damage: float
var speed: float
var attack_range: float = 55.0
var num_targets: int
var element: GameManager.Element

var can_attack: bool = true

func set_stats() -> void: # Used by child classes
	pass

func _ready():
	set_stats()

	# Configure Area2D
	area.area_entered.connect(on_area_entered)
	area.area_exited.connect(on_area_exited)

	# Configure CollisionShape2D
	var shape: CircleShape2D = collider.shape
	shape.radius = attack_range

	# Configure Timer
	attack_timer.timeout.connect(on_attack_timer_timeout)
	add_child(attack_timer)

func _physics_process(_delta):
	if can_attack:
		attack()

		# Restart attack timer
		can_attack = false
		attack_timer.start(speed)

func attack() -> void:
	for enemy in active_targets:
		var is_dead: bool = enemy.take_damage(damage, element)
		if is_dead:
			active_targets.remove_at(active_targets.find(enemy))
			update_active_targets()

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
	while active_targets.size() < num_targets and inactive_targets.size() > 0:
		active_targets.append(inactive_targets.pop_front())

func on_attack_timer_timeout() -> void:
	can_attack = true
