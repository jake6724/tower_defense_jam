class_name Tower
extends Node2D

@export var tower_data: TowerData

# Child references
@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var transform_area: Area2D = %TransformArea
@onready var collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var ap: AnimationPlayer = $AnimationPlayer

var active_target: Enemy
var in_range_targets: Array[Enemy] = []
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

# Bullets
var bullets: Dictionary[GameManager.Element, PackedScene] = {
	GameManager.Element.FIRE: preload("res://scenes/towers/bullets/FireBullet.tscn"),
	GameManager.Element.EARTH: preload("res://scenes/towers/bullets/EarthBullet.tscn"),
	GameManager.Element.WATER: preload("res://scenes/towers/bullets/WaterBullet.tscn"),
}

# Debug
var debug_attack_line: Line2D = Line2D.new()

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
	attack_timer.one_shot = true
	add_child(attack_timer)
	attack_timer.start(speed)

	transform_timer.timeout.connect(on_transform_timer_timeout)
	transform_timer.one_shot = true
	add_child(transform_timer)
	transform_timer.start(.1) # time until you can transform a tower (so it doesn't when you click to spawn it)

	debug_attack_line.width = 4
	add_child(debug_attack_line)

func _physics_process(_delta):	
	if can_attack:
		update_active_target()
		if active_target:
			attack()
			can_attack = false
			attack_timer.start(speed)
	else:
		ap.play("idle")

func attack() -> void:
	spawn_bullet()

func update_active_target() -> void:
	var selected_target: Enemy
	var shortest_path = INF
	var shortest_distance_to_waypoint = Vector2(INF, INF)

	if in_range_targets.size() == 0:
		active_target = null
		return

	for enemy: Enemy in in_range_targets:
		if enemy.is_alive and enemy.path.size() < shortest_path: # May need to remove if dead here
			shortest_path = enemy.path.size()
			# check distance to next WP in path
			if (position - enemy.path[0]) <= shortest_distance_to_waypoint:
				selected_target = enemy

	active_target = selected_target

func on_enemy_is_dead(enemy: Enemy) -> void:
	var index = in_range_targets.find(enemy)
	if index != -1:
		in_range_targets.remove_at(index)

	if enemy == active_target: 
		active_target = null
		
func on_area_entered(intruder: Area2D) -> void:
	if intruder is Enemy:
		in_range_targets.append(intruder)
		intruder.is_dead.connect(on_enemy_is_dead)

func on_area_exited(intruder) -> void:
	if intruder is Enemy:
		if intruder == active_target:
			active_target = null

		if intruder in in_range_targets:
			in_range_targets.remove_at(in_range_targets.find(intruder))
			intruder.is_dead.disconnect(on_enemy_is_dead)

func spawn_bullet() -> void:
	var new_bullet: Bullet = bullets[element].instantiate()
	new_bullet.element = element
	new_bullet.damage = int(damage)
	new_bullet.target = active_target
	new_bullet.position += new_bullet.pos_offset
	add_child(new_bullet)

func on_transform_area_pressed(_viewport, _event, _shape_idx) -> void:
	if can_transform:
		if Input.is_action_just_pressed("left_click"):
			can_transform = false
			transform_tower.emit()

func on_attack_timer_timeout() -> void:
	can_attack = true

func on_transform_timer_timeout() -> void:
	can_transform = true
