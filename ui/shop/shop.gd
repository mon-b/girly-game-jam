extends CanvasLayer

const ITEMS = {
	"lamp": preload("res://scenes/furniture/lamp.tscn"),
	"tv": preload("res://scenes/furniture/tv.tscn"),
	"tub": preload("res://scenes/furniture/tub.tscn"),
	"cat": preload("res://scenes/furniture/cat.tscn"),
}

func _ready() -> void:
	$Panel/CenterContainer/VBoxContainer/row/lamp.pressed.connect(_on_item_pressed.bind(ITEMS["lamp"]))
	$Panel/CenterContainer/VBoxContainer/row/tv.pressed.connect(_on_item_pressed.bind(ITEMS["tv"]))
	$Panel/CenterContainer/VBoxContainer/row/tub.pressed.connect(_on_item_pressed.bind(ITEMS["tub"]))
	$Panel/CenterContainer/VBoxContainer/row2/cat.pressed.connect(_on_item_pressed.bind(ITEMS["cat"]))

func _on_item_pressed(scene: PackedScene) -> void:
	Global.placing_item = scene
	visible = false
