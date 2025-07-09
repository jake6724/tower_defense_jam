class_name TowerMenu
extends Control

# Child References
@onready var fire_button: TextureButton = $MarginContainer/HBoxContainer/Fire/FireButton
@onready var water_button: TextureButton = $MarginContainer/HBoxContainer/Water/WaterButton
@onready var earth_button: TextureButton = $MarginContainer/HBoxContainer/Earth/EarthButton
@onready var gold: Label = $MarginContainer/Gold/Gold
@onready var wave_button: TextureButton = $MarginContainer/HBoxContainer2/WaveButton

# Signals
signal tower_selected
signal start_wave
signal mouse_entered_button
signal mouse_exited_button

func _ready():
	# Configure buttons
	var buttons: Array[TextureButton] = [fire_button, water_button, earth_button]
	for b: TextureButton in buttons:
			b.pressed.connect(on_button_pressed.bind(b))
			b.mouse_entered.connect(on_mouse_entered_button)
			b.mouse_exited.connect(on_mouse_exited_button)

	wave_button.pressed.connect(on_wave_button_pressed)

func on_button_pressed(pressed_button: TextureButton):
	var b_name: String = pressed_button.name.to_lower()
	match b_name:
		"firebutton": tower_selected.emit("fire")
		"waterbutton": tower_selected.emit("water")
		"earthbutton": tower_selected.emit("earth")

## Intended to be called by `player_controller` to directly update gold count
func update_gold(new_amount: int) -> void:
	gold.text = str(new_amount)

func on_wave_button_pressed() -> void:
	# Button pressed -> Player Controller triggers GM -> GM triggers enemy spawner
	start_wave.emit()

func on_mouse_entered_button():
	mouse_entered_button.emit()

func on_mouse_exited_button():
	mouse_exited_button.emit()
