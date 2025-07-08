extends Node2D

var enemy: PackedScene = preload("res://scenes/enemies/TestEnemy.tscn")

func _input(_event):
	if Input.is_action_just_pressed("spawn_enemy"):
		var pos: Vector2 = GameManager.grid_to_world(GameManager.world_to_grid(get_global_mouse_position()))
		var new_enemy: Enemy = enemy.instantiate()
		new_enemy.position = pos
		add_child(new_enemy)