extends TextureButton

const ShopScene = preload("res://ui/shop/shop.tscn")

var shop_instance = null

func _ready() -> void:
	pressed.connect(_on_shop_pressed)

func _on_shop_pressed() -> void:
	if shop_instance == null:
		shop_instance = ShopScene.instantiate()
		get_tree().root.add_child(shop_instance)
	else:
		shop_instance.visible = !shop_instance.visible
	Global.shop_open = shop_instance.visible
