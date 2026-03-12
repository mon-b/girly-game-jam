extends CanvasLayer

const ITEMS = {
	"lamp": preload("res://scenes/furniture/floor/lamp.tscn"),
	"tv": preload("res://scenes/furniture/floor/tv.tscn"),
	"tub": preload("res://scenes/furniture/floor/tub.tscn"),
	"cat": preload("res://scenes/furniture/floor/cat.tscn"),
	"mirror": preload("res://scenes/furniture/wall/mirror.tscn"),
	"painting": preload("res://scenes/furniture/wall/painting.tscn"),
}

func _ready() -> void:
	$Panel/CenterContainer/VBoxContainer/row/lamp.pressed.connect(_on_item_pressed.bind(ITEMS["lamp"]))
	$Panel/CenterContainer/VBoxContainer/row/tv.pressed.connect(_on_item_pressed.bind(ITEMS["tv"]))
	$Panel/CenterContainer/VBoxContainer/row/tub.pressed.connect(_on_item_pressed.bind(ITEMS["tub"]))
	$Panel/CenterContainer/VBoxContainer/row2/cat.pressed.connect(_on_item_pressed.bind(ITEMS["cat"]))
	$Panel/CenterContainer/VBoxContainer/row2/mirror.pressed.connect(_on_item_pressed.bind(ITEMS["mirror"]))
	$Panel/CenterContainer/VBoxContainer/row2/painting.pressed.connect(_on_item_pressed.bind(ITEMS["painting"]))
	

func _on_item_pressed(scene: PackedScene) -> void:
	Global.placing_item = scene
	visible = false
