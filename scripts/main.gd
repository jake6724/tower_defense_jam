class_name Main
extends Node2D

@onready var round_info: RoundInfo = $UI/RoundInfo

func _ready():
	GameManager.configure_level()

func pause_game():
	get_tree().paused = true

func unpause_game():
	get_tree().paused = false
