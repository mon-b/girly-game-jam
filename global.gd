extends Node

const TYPE_FURNITURE = "furniture"
const TYPE_FLOOR = "floor"
const TYPE_WALLPAPER = "wallpaper"
const TYPE_HOUSE_COLOR = "house_color"

var shop_open: bool = false
var placing_item = null
var placing_type: String = ""
var placing_item_price: int = 0
var type_placing_item: String = ""
var placed_furniture: Array = []
var room_states: Array = []
var current_house_color_price: int = 0
var current_house_color: Color = Color("ffcddfff")

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
