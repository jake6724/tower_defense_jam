# Autoloader
extends Node

var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
var track_1: AudioStreamOggVorbis = load("res://audio/Theme-1_Auto.ogg")
var start_track = track_1

func _ready():
	# Configure AudioStreamPlayer
	music_player.volume_db = -25
	add_child(music_player)
	music_player.stream = track_1
	music_player.play()