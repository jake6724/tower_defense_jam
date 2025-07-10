class_name Base
extends Node2D

@onready var ap: AnimationPlayer = $AnimationPlayer

var health: int = 100

signal was_destroyed

func _physics_process(_delta):
	ap.play("idle")

func take_damage(damage_recieved: int):
	health -= damage_recieved
	print("Damage taken. New HP: ", health)

	if health <= 0:
		was_destroyed.emit()