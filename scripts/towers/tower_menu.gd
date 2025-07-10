class_name TowerMenu
extends Control

# Child References
@onready var fire_button: TextureButton = %FireButton
@onready var water_button: TextureButton = %WaterButton
@onready var earth_button: TextureButton = %EarthButton
@onready var tower_buttons: HBoxContainer = %TowerButtons
@onready var gold: Label = %Gold
@onready var wave_button: TextureButton = %WaveButton
@onready var wave_number: Label = %WaveNumber
@onready var level_number: Label = %LevelNumber

# Signals
signal tower_selected
signal start_wave
signal mouse_entered_button
signal mouse_exited_button

var wave_number_timer: Timer = Timer.new()
var wave_number_duration: float = 1.0

var level_number_timer: Timer = Timer.new()
var level_number_duration: float = 1.0

func _ready():
	# Configure buttons
	var buttons: Array[TextureButton] = [fire_button, water_button, earth_button]
	for b: TextureButton in buttons:
			b.pressed.connect(on_button_pressed.bind(b))
			b.mouse_entered.connect(on_mouse_entered_button)
			b.mouse_exited.connect(on_mouse_exited_button)

	wave_button.pressed.connect(on_wave_button_pressed)
	wave_button.mouse_entered.connect(on_mouse_entered_button)
	wave_button.mouse_exited.connect(on_mouse_exited_button)

	# Configure timers
	wave_number_timer.timeout.connect(on_wave_number_timer_timeout)
	wave_number_timer.one_shot = true
	add_child(wave_number_timer)

	level_number_timer.timeout.connect(on_level_number_timer_timeout)
	level_number_timer.one_shot = true
	add_child(level_number_timer)

func hide_placement_phase() -> void:
	tower_buttons.hide()
	wave_button.hide()

func show_placement_phase() -> void:
	tower_buttons.show()
	wave_button.show()

func show_level_number() -> void:
	level_number.text = "Level " + str(GameManager.level_index + 1)
	level_number.show()
	# Start timer which will automatically hide level number after timeout
	level_number_timer.start(level_number_duration)

func on_button_pressed(pressed_button: TextureButton):
	var b_name: String = pressed_button.name.to_lower()
	match b_name:
		"firebutton": tower_selected.emit("fire")
		"waterbutton": tower_selected.emit("water")
		"earthbutton": tower_selected.emit("earth")

func on_wave_number_timer_timeout():
	wave_number.hide()

func on_level_number_timer_timeout():
	level_number.hide()

## Intended to be called by `player_controller` to directly update gold count
func update_gold(new_amount: int) -> void:
	gold.text = str(new_amount)

func on_wave_button_pressed() -> void:
	wave_number.text = "Wave " + str(EnemySpawner.wave_index+1)
	wave_number.show()
	wave_number_timer.start(wave_number_duration)
	start_wave.emit()

func on_mouse_entered_button():
	mouse_entered_button.emit()

func on_mouse_exited_button():
	mouse_exited_button.emit()
