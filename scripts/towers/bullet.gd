class_name Bullet
extends Sprite2D

@onready var ap: AnimationPlayer = $AnimationPlayer

var element: GameManager.Element
var damage: int 
var target: Enemy

var pos_offset: Vector2 = Vector2(8,8) # Hard-code works unless tower sprite size changes
var min_distance: float = 11
var speed: float = 100

func _physics_process(delta):
	if target and target.is_alive:
		if global_position.distance_to(target.global_position) > min_distance:
			ap.play("move")
			global_position = global_position + ((global_position.direction_to(target.global_position + pos_offset)) * speed * delta)
		
		else: # If target has been reached
			target.take_damage(damage, element)
			queue_free()

	else: # Do nothing if target is null or dead
		queue_free()
