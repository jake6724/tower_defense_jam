# Autoloader
extends Node

var num_players: int = 32
var players: Array[AudioStreamPlayer] = []
var volume: float = -25.0

var sfxs: Dictionary[String, AudioStreamOggVorbis] = {
	"fire_shot": preload("res://audio/sfx/Fire_Shot.ogg"),
	"water_shot": preload("res://audio/sfx/Water_Shot.ogg"),
	"earth_shot": preload("res://audio/sfx/Earth_Shot .ogg"),
	"go": preload("res://audio/sfx/Go_2.ogg"),
	"fire_select": preload("res://audio/sfx/Fire_Selection.ogg"),
	"earth_select": preload("res://audio/sfx/Earth_Selection.ogg"),
	"water_select": preload("res://audio/sfx/Water_Selection.ogg"),
	"fire_explosion": preload("res://audio/sfx/Fire_Explosion.ogg"),
	"earth_explosion": preload("res://audio/sfx/Earth_Explosion.ogg"),
	"water_explosion": preload("res://audio/sfx/Water_Explosion.ogg"),
}

func _ready():
	# Create num_players amount of AudioStreamPlayers
	for i in range(num_players):
		var new_player: AudioStreamPlayer = AudioStreamPlayer.new()
		new_player.volume_db = volume
		new_player.bus = "sfx"
		add_child(new_player)
		players.append(new_player)

func play_sfx(sfx_name: String):
	var sfx_stream: AudioStreamOggVorbis = sfxs[sfx_name]
	var p: AudioStreamPlayer = get_best_player()
	p.stream = sfx_stream
	p.play()

## Return the first available or least recently used AudioStreamPlayer
func get_best_player() -> AudioStreamPlayer:
	# Check if there are any used players
	for p: AudioStreamPlayer in players:
		if not p.playing:
			# print(p)
			return p

	# If none free, find the least recently used
	var max_playback_position: float = INF
	var lru_player: AudioStreamPlayer
	for p: AudioStreamPlayer in players:
		if p.get_playback_position() < max_playback_position:
			max_playback_position = p.get_playback_position()
			lru_player = p

	print(lru_player)
	return lru_player
