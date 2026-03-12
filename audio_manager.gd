extends Node

@onready var music_player: AudioStreamPlayer2D = $MusicPlayer

var music_bus_index: int = -1
var current_music_path: String = ""

func _ready():
	music_bus_index = AudioServer.get_bus_index("Music")
	if music_bus_index == -1:
		print("Music bus said nope")

# ============================
# Functions
# ============================

# Play a specific music track (called when starting a new scene)
func play_music(music_path: String, volume_offset_db: float = 0.0):
	if music_path == current_music_path and music_player.playing:
		return  # already playing this track → no need to restart
	
	stop_music() # stop first to avoid overlap
	
	var stream = load(music_path) as AudioStream
	if stream:
		music_player.stream = stream
		music_player.volume_db = volume_offset_db
		music_player.play()
		current_music_path = music_path
	else:
		print("Music said nope | path: " + music_path)

# Stop whatever is playing
func stop_music():
	music_player.stop()
	current_music_path = ""

# Set volume as percentage (0 = silent, 100 = full)
func set_music_volume(percent: float):
	if music_bus_index == -1: return
	var clamped = clamp(percent / 100.0, 0.0, 1.0)
	AudioServer.set_bus_volume_linear(music_bus_index, clamped)
