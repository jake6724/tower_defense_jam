class_name TutorialLevelEnvironment
extends LevelEnvironment

@onready var ui: TutorialUI = $UI/TutorialUI

func _ready():
	EnemySpawner.wave_complete.connect(on_wave_complete)

func on_wave_complete():
	pass

func _input(_event):
	if Input.is_action_just_pressed("spacebar"):
		ui.db_1.hide()
		ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
