extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenu.show()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	#pass


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
	


func _on_credits_button_pressed() -> void:
	$Credits.show()
	$MainMenu.hide()




func _on_go_back_button_pressed() -> void:
	$Credits.hide()
	$MainMenu.show()
	
