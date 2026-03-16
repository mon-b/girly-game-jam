extends CanvasLayer

const ITEMS = {
	"lamp": preload("res://scenes/furniture/floor/lamp.tscn"),
	"tv": preload("res://scenes/furniture/floor/tv.tscn"),
	"tub": preload("res://scenes/furniture/floor/tub.tscn"),
	"cat": preload("res://scenes/furniture/floor/cat.tscn"),
	"mirror": preload("res://scenes/furniture/wall/mirror.tscn"),
	"painting": preload("res://scenes/furniture/wall/painting.tscn"),
	"bookcase": preload("res://scenes/furniture/floor/bookcase.tscn"),
	"fridge": preload("res://scenes/furniture/floor/fridge.tscn"),
	"kitchen_stove": preload("res://scenes/furniture/floor/kitchen_stove.tscn"),
	"shelf": preload("res://scenes/furniture/floor/shelf.tscn"),
	"wc": preload("res://scenes/furniture/floor/wc.tscn"),
	"bed": preload("res://scenes/furniture/floor/bed.tscn"),
	"bathroom_sink": preload("res://scenes/furniture/floor/bathroom_sink.tscn"),
	"sofa": preload("res://scenes/furniture/floor/sofa.tscn"),
	"sofa2": preload("res://scenes/furniture/floor/sofa2.tscn"),
	"table": preload("res://scenes/furniture/floor/table.tscn"),
	"drawers": preload("res://scenes/furniture/floor/drawers.tscn"),
	"flower": preload("res://scenes/furniture/floor/flower.tscn"),
	"coffee_machine": preload("res://scenes/furniture/floor/coffee_machine.tscn"),
	"cat_feeder": preload("res://scenes/furniture/floor/cat_feeder.tscn"),
	"kitchen_deco1": preload("res://scenes/furniture/wall/kitchen_deco1.tscn"),
	"kitchen_deco2": preload("res://scenes/furniture/wall/kitchen_deco2.tscn"),
	"photos": preload("res://scenes/furniture/wall/photos.tscn"),
	"window": preload("res://scenes/furniture/wall/window.tscn"),
	"window2": preload("res://scenes/furniture/wall/window2.tscn"),
}

const PRICES = {
	"lamp": 50,
	"tv": 300,
	"tub": 200,
	"cat": 150,
	"mirror": 80,
	"painting": 120,
	"bookcase": 180,
	"fridge": 350,
	"kitchen_stove": 400,
	"shelf": 100,
	"wc": 150,
	"bed": 500,
	"bathroom_sink": 130,
	"sofa": 450,
	"sofa2": 450,
	"table": 200,
	"drawers": 160,
	"flower": 40,
	"coffee_machine": 250,
	"cat_feeder": 60,
	"kitchen_deco1": 70,
	"kitchen_deco2": 70,
	"photos": 50,
	"window": 90,
	"window2": 90,
}


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and visible:
		visible = false

func _ready() -> void:
	Global.money_label = $Panel/CenterContainer/VBoxContainer/MoneyRow/MoneyBox/MoneyLabel
	Global.update_money(0)
	for item_name in ITEMS:
		var btn = _find_button(item_name)
		if btn:
			btn.pressed.connect(_on_item_pressed.bind(item_name))

func _find_button(item_name: String) -> TextureButton:
	for row in $Panel/CenterContainer/VBoxContainer.get_children():
		var btn = row.get_node_or_null(item_name)
		if btn:
			return btn
	return null
	

func _on_item_pressed(item_name: String) -> void:
	if Global.has_money(PRICES[item_name]):
		Global.update_money(-PRICES[item_name])
		
		var scene: PackedScene = ITEMS[item_name]
		Global.placing_item = scene

		if "/wall/" in scene.resource_path:
			Global.type_placing_item = "wall"
		elif "/floor/" in scene.resource_path:
			Global.type_placing_item = "floor"

		visible = false
