class_name Bullet
extends Sprite2D

@onready var ap: AnimationPlayer = $AnimationPlayer

var element: GameManager.Element
var damage: int 
var speed: int
var target: int

func _init(element, damage, target):
	pass