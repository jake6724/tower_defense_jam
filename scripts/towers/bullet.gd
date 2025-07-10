class_name Bullet
extends Sprite2D

@onready var ap: AnimationPlayer = $AnimationPlayer

var element: GameManager.Element
var damage: int 
var target: Enemy

var min_distance: float = 1
var speed: float = 100

func _physics_process(delta):
	if target and target.is_alive:
		print(global_position.distance_to(target.global_position))
		if global_position.distance_to(target.global_position) > min_distance:
			ap.play("move")
			global_position = global_position + ((global_position.direction_to(target.global_position)) * speed * delta)
		else:
			queue_free()
	else:
		queue_free()
