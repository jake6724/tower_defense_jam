class_name Main
extends Node2D

@onready var round_info: RoundInfo = $UI/RoundInfo

func _ready():
	GameManager.configure_level()
