extends Node

var placing_item: PackedScene = null
var type_placing_item: String = ""
var placed_furniture: Array = []

func change_scene(scene : String):
	AudioManager.stop_music()
	get_tree().call_deferred("change_scene_to_file", scene)

var money: int = 200
var money_label: Label = null

func has_money(value):
	return value <= money

func update_money(value):
	money += value
	money_label.text = str(money)
