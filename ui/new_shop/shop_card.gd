extends Panel

signal buy_pressed(item_name)

func setup(item_name: String, price: int, texture: Texture2D, stretch: int = TextureRect.STRETCH_KEEP_ASPECT_CENTERED) -> void:
	$VBoxContainer/TextureRect.texture = texture
	$VBoxContainer/TextureRect.stretch_mode = stretch
	$VBoxContainer/BottomRow/PricePanel/PriceLabel.text = str(price)
	$VBoxContainer/BottomRow/BuyButton.pressed.connect(
		func(): buy_pressed.emit(item_name)
	)
