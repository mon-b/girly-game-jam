extends Control

@onready var master_slider: HSlider = $GameVolume
@onready var music_slider:  HSlider = $MusicVolume

var master_bus_index: int = -1
var music_bus_index:  int = -1

func _ready():
	master_bus_index = AudioServer.get_bus_index("Master")
	music_bus_index  = AudioServer.get_bus_index("Music")
	
	if master_bus_index == -1:
		print("Master bus said nope")
	if music_bus_index == -1:
		print("Music bus said nope")
	
	# Load current volumes into sliders
	update_sliders()

# ========================
# Volume sliders
# ========================

func update_sliders():
	if master_bus_index != -1:
		var linear = AudioServer.get_bus_volume_linear(master_bus_index)
		master_slider.value = round(linear * 100)
	if music_bus_index != -1:
		var linear = AudioServer.get_bus_volume_linear(music_bus_index)
		music_slider.value = round(linear * 100)

func _on_game_volume_value_changed(value: float):
	if master_bus_index != -1:
		AudioServer.set_bus_volume_linear(master_bus_index, value / 100.0)

func _on_music_volume_value_changed(value: float):
	if music_bus_index != -1:
		AudioServer.set_bus_volume_linear(music_bus_index, value / 100.0)
