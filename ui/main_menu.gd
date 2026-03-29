extends Node2D

@onready var play = $Play
@onready var options = $Options

@onready var options_modal = $OptionsModal
@onready var close_options = $OptionsModal/CloseOptions

func _ready():
	AudioManager.play_music("res://assets/audio/music/MainMenu.mp3", -4)

func _on_play_pressed():
	AudioManager.play_sfx("res://assets/audio/sfx/Menu 1.wav", 0)
	Global.change_scene("res://ui/menu.tscn")

func _on_options_pressed():
	AudioManager.play_sfx("res://assets/audio/sfx/Menu 1.wav", 0)
	options_modal.update_sliders()
	options_modal.show()

func _on_close_options_pressed():
	AudioManager.play_sfx("res://assets/audio/sfx/Menu 1.wav", 0)
	options_modal.hide()
