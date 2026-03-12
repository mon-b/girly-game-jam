extends Node

var placing_item: PackedScene = null
var type_placing_item: String = ""

func change_scene(scene : String):
	AudioManager.stop_music()
	get_tree().call_deferred("change_scene_to_file", scene)
