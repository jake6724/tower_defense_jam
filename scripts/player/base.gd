class_name Base
extends Node2D

@onready var ap: AnimationPlayer = $AnimationPlayer

var health: int = 10

signal base_destroyed

func _physics_process(_delta):
	ap.play("idle")

func take_damage(damage_recieved: int):
	health -= damage_recieved
	%HealthLabel.text = str(health)

	# print("Damage taken. New HP: ", health)

	if health <= 0:
		base_destroyed.emit()