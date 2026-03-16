extends TextureButton

const ShopScene = preload("res://ui/shop/shop.tscn")

const ITEMS = {
	"Panel/CenterContainer/VBoxContainer/row1/tub": preload("res://scenes/furniture/floor/tub.tscn"),
	"Panel/CenterContainer/VBoxContainer/row1/bathroom_sink": preload("res://scenes/furniture/floor/bathroom_sink.tscn"),
	"Panel/CenterContainer/VBoxContainer/row1/wc": preload("res://scenes/furniture/floor/wc.tscn"),
	"Panel/CenterContainer/VBoxContainer/row1/mirror": preload("res://scenes/furniture/wall/mirror.tscn"),
	"Panel/CenterContainer/VBoxContainer/row1/photos": preload("res://scenes/furniture/wall/photos.tscn"),
	"Panel/CenterContainer/VBoxContainer/row1/window": preload("res://scenes/furniture/wall/window.tscn"),
	"Panel/CenterContainer/VBoxContainer/row1/window2": preload("res://scenes/furniture/wall/window2.tscn"),
	"Panel/CenterContainer/VBoxContainer/row2/cat": preload("res://scenes/furniture/floor/cat.tscn"),
	"Panel/CenterContainer/VBoxContainer/row2/cat_feeder": preload("res://scenes/furniture/floor/cat_feeder.tscn"),
	"Panel/CenterContainer/VBoxContainer/row2/lamp": preload("res://scenes/furniture/floor/lamp.tscn"),
	"Panel/CenterContainer/VBoxContainer/row2/tv": preload("res://scenes/furniture/floor/tv.tscn"),
	"Panel/CenterContainer/VBoxContainer/row2/painting": preload("res://scenes/furniture/wall/painting.tscn"),
	"Panel/CenterContainer/VBoxContainer/row2/flower": preload("res://scenes/furniture/floor/flower.tscn"),
	"Panel/CenterContainer/VBoxContainer/row3/fridge": preload("res://scenes/furniture/floor/fridge.tscn"),
	"Panel/CenterContainer/VBoxContainer/row3/kitchen_stove": preload("res://scenes/furniture/floor/kitchen_stove.tscn"),
	"Panel/CenterContainer/VBoxContainer/row3/coffee_machine": preload("res://scenes/furniture/floor/coffee_machine.tscn"),
	"Panel/CenterContainer/VBoxContainer/row3/table": preload("res://scenes/furniture/floor/table.tscn"),
	"Panel/CenterContainer/VBoxContainer/row3/kitchen_deco1": preload("res://scenes/furniture/wall/kitchen_deco1.tscn"),
	"Panel/CenterContainer/VBoxContainer/row3/kitchen_deco2": preload("res://scenes/furniture/wall/kitchen_deco2.tscn"),
	"Panel/CenterContainer/VBoxContainer/row4/bed": preload("res://scenes/furniture/floor/bed.tscn"),
	"Panel/CenterContainer/VBoxContainer/row4/sofa": preload("res://scenes/furniture/floor/sofa.tscn"),
	"Panel/CenterContainer/VBoxContainer/row4/sofa2": preload("res://scenes/furniture/floor/sofa2.tscn"),
	"Panel/CenterContainer/VBoxContainer/row4/bookcase": preload("res://scenes/furniture/floor/bookcase.tscn"),
	"Panel/CenterContainer/VBoxContainer/row4/shelf": preload("res://scenes/furniture/floor/shelf.tscn"),
	"Panel/CenterContainer/VBoxContainer/row4/shelf2": preload("res://scenes/furniture/floor/shelf2.tscn"),
	"Panel/CenterContainer/VBoxContainer/row4/drawers": preload("res://scenes/furniture/floor/drawers.tscn"),
}

var shop_instance = null

func _ready() -> void:
	pressed.connect(_on_shop_pressed)

func _on_shop_pressed() -> void:
	if shop_instance == null:
		shop_instance = ShopScene.instantiate()
		get_tree().root.add_child(shop_instance)
	else:
		shop_instance.visible = !shop_instance.visible
