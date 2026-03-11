extends TextureButton

const ShopScene = preload("res://ui/shop/shop.tscn")

const ITEMS = {
	"Panel/CenterContainer/VBoxContainer/row/lamp": preload("res://scenes/furniture/lamp.tscn"),
	"Panel/CenterContainer/VBoxContainer/row/tv": preload("res://scenes/furniture/tv.tscn"),
	"Panel/CenterContainer/VBoxContainer/row/tub": preload("res://scenes/furniture/tub.tscn"),
	"Panel/CenterContainer/VBoxContainer/row2/cat": preload("res://scenes/furniture/cat.tscn"),
}

var shop_instance = null

func _ready() -> void:
	pressed.connect(_on_shop_pressed)

func _on_shop_pressed() -> void:
	if shop_instance == null:
		shop_instance = ShopScene.instantiate()
		get_tree().root.add_child(shop_instance)
		_connect_items()
	else:
		shop_instance.visible = !shop_instance.visible

func _connect_items() -> void:
	for path in ITEMS:
		var btn = shop_instance.get_node_or_null(path)
		if btn:
			btn.button_mask = MOUSE_BUTTON_MASK_LEFT
			btn.pressed.connect(_on_item_pressed.bind(ITEMS[path]))

func _on_item_pressed(scene: PackedScene) -> void:
	Global.placing_item = scene
	shop_instance.visible = false
