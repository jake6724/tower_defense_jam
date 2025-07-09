class_name TowerMenu
extends Control

# Child References
@onready var button_container: HBoxContainer = $HBoxContainer
@onready var fire_button: TextureButton = $HBoxContainer/HBoxContainer/FireButton
@onready var water_button: TextureButton = $HBoxContainer/HBoxContainer2/WaterButton
@onready var earth_button: TextureButton = $HBoxContainer/HBoxContainer3/EarthButton

# Signals
signal tower_selected
signal mouse_entered_button
signal mouse_exited_button

func _ready():
	# Configure buttons
	for child in button_container.get_children():
		if child is TextureButton:
			child.pressed.connect(on_button_pressed.bind(child))
			child.mouse_entered.connect(on_mouse_entered_button)
			child.mouse_exited.connect(on_mouse_exited_button)

func on_button_pressed(pressed_button: TextureButton):
	var b_name: String = pressed_button.name.to_lower()
	match b_name:
		"firebutton": tower_selected.emit("fire")
		"waterbutton": tower_selected.emit("water")
		"earthbutton": tower_selected.emit("earth")

func on_mouse_entered_button():
	mouse_entered_button.emit()

func on_mouse_exited_button():
	mouse_exited_button.emit()
