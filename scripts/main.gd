extends Node2D

func _input(_event):
	if Input.is_action_just_pressed("left_click"):
		print(GameManager.world_to_grid(get_global_mouse_position()))