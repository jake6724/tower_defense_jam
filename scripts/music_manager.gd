# Autoloader
extends Node

var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
var track_1: AudioStreamOggVorbis = preload("res://audio/music/Theme-1_Auto.ogg")
# var track_2: AudioStreamOggVorbis = preload("res://audio/music/Theme-2_Auto.ogg")
var start_track = track_1

func _ready():
	# Configure AudioStreamPlayer
	music_player.volume_db = -16
	add_child(music_player)
	music_player.stream = track_1
	music_player.play()