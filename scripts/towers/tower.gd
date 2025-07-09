class_name Tower
extends Node2D

@export var tower_data: TowerData

# Child references
@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var transform_area: Area2D = %TransformArea
@onready var collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var ap: AnimationPlayer = $AnimationPlayer

var active_targets: Array[Enemy] = []
var inactive_targets: Array[Enemy] = []
var attack_timer: Timer = Timer.new()
var transform_timer: Timer = Timer.new()
var can_transform: bool = false

# Tower stats
var damage: float
var speed: float
var attack_range: float = 55.0
var num_targets: int
var element: GameManager.Element
var tower_name: String

var can_attack: bool = true

signal transform_tower

func _ready():
	element = tower_data.element
	damage = tower_data.damage
	speed = tower_data.speed
	attack_range = tower_data.attack_range
	num_targets = tower_data.num_targets
	tower_name = tower_data.tower_name
	
	# Configure Area2D
	area.area_entered.connect(on_area_entered)
	area.area_exited.connect(on_area_exited)

	# Configure Transforming
	transform_area.input_event.connect(on_transform_area_pressed)

	# Configure CollisionShape2D
	var shape: CircleShape2D = collider.shape
	shape.radius = attack_range

	# Configure Timers
	attack_timer.timeout.connect(on_attack_timer_timeout)
	add_child(attack_timer)

	transform_timer.timeout.connect(on_transform_timer_timeout)
	transform_timer.one_shot = true
	add_child(transform_timer)
	transform_timer.start(.1) # time until you can transform a tower (so it doesn't when you click to spawn it)

func _physics_process(_delta):	
	if can_attack:
		attack()
		# Restart attack timer
		can_attack = false
		attack_timer.start(speed)
	else:
		ap.play("idle")

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

func on_transform_area_pressed(_viewport, _event, _shape_idx) -> void:
	if can_transform:
		if Input.is_action_just_pressed("left_click"):
			can_transform = false
			transform_tower.emit()
			print("Transform button pressed!")

func update_active_targets() -> void:
	# Move as many inactive targets to active as possible/allowed
	while active_targets.size() < num_targets and inactive_targets.size() > 0:
		active_targets.append(inactive_targets.pop_front())

func on_attack_timer_timeout() -> void:
	can_attack = true

func on_transform_timer_timeout() -> void:
	can_transform = true
