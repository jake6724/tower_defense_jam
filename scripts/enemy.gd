class_name Enemy
extends Area2D

# Child references
@onready var sprite: Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D

# TODO: Could add jittering to enemy placement, so that multiple small enemies could be on 1 grid point but not all stack

var path: PackedVector2Array = [Vector2(32.0, 224.0),Vector2(64.0, 224.0), Vector2(96.0, 224.0), Vector2(128.0, 224.0), Vector2(160.0, 224.0),Vector2(192.0, 224.0), Vector2(224.0, 224.0), Vector2(224.0, 192.0), Vector2(256.0, 192.0), Vector2(288.0, 192.0), Vector2(288.0, 160.0), Vector2(320.0, 160.0), Vector2(320.0, 128.0), Vector2(320.0, 96.0), Vector2(352.0, 96.0), Vector2(352.0, 64.0), Vector2(384.0, 64.0)]
var min_distance: float = 5.0

# Enemy Stats
var speed: float = 300.0

# func _ready():
# 	position = GameManager.grid_to_world(path[0])

func _process(delta):
	move(delta)

func move(delta) -> void:
	if path:
		print(position)
		if position.distance_to(path[0]) > min_distance:
			position += (path[0] - position).normalized() * speed * delta

		else:
			position = path[0]
			path.remove_at(0)
