class_name Base
extends Node2D

@onready var ap: AnimationPlayer = $AnimationPlayer

func _physics_process(_delta):
	ap.play("idle")