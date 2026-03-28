extends CanvasLayer

const ShopCard = preload("res://ui/new_shop/shop_card.tscn")
const FURNITURE = preload("res://assets/sprites/Furniture.png")

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

const TEXTURES = {
	"tub": Rect2(272, 32, 64, 48),
	"bathroom_sink": Rect2(288, 96, 32, 32),
	"wc": Rect2(448, 48, 32, 32),
	"mirror": Rect2(336, 96, 32, 32),
	"photos": Rect2(320, 144, 48, 32),
	"window": Rect2(64, 144, 48, 32),
	"window2": Rect2(128, 144, 32, 32),
	"cat": Rect2(352, 32, 32, 48),
	"cat_feeder": Rect2(128, 96, 16, 32),
	"lamp": Rect2(128, 32, 16, 48),
	"tv": Rect2(80, 32, 32, 48),
	"painting": Rect2(384, 144, 32, 32),
	"flower": Rect2(206, 144, 19, 32),
	"fridge": Rect2(544, 32, 32, 48),
	"kitchen_stove": Rect2(496, 32, 32, 48),
	"coffee_machine": Rect2(544, 80, 32, 48),
	"drawers": Rect2(176, 144, 16, 32),
	"table": Rect2(224, 96, 48, 32),
	"kitchen_deco1": Rect2(384, 96, 32, 32),
	"kitchen_deco2": Rect2(432, 96, 48, 32),
	"bed": Rect2(48, 96, 64, 32),
	"sofa": Rect2(160, 96, 48, 32),
	"sofa2": Rect2(240, 144, 64, 32),
	"bookcase": Rect2(160, 32, 32, 48),
	"shelf": Rect2(208, 16, 48, 64),
}


const FLOOR_TEXTURES = {
	"floor_basic_pink": preload("res://assets/ui/house/floor/Floor-basic-pink.png"),
	"floor_basic_blue": preload("res://assets/ui/house/floor/Floor-basic-blue.png"),
	"floor_basic_purple": preload("res://assets/ui/house/floor/Floor-basic-purple.png"),
	"floor_basic_turquoise": preload("res://assets/ui/house/floor/Floor-basic-turquoise.png"),
	"floor_basic": preload("res://assets/ui/house/floor/Floor-basic.png"),
	"floor_wood_caramel": preload("res://assets/ui/house/floor/Floor-wood-caramel.png"),
	"floor_vwood_caramel": preload("res://assets/ui/house/floor/Floor-vwood-caramel.png"),
	"floor_vwood_beige": preload("res://assets/ui/house/floor/Floor-vwood-beige.png"),
	"floor_tiles_pink": preload("res://assets/ui/house/floor/Floor-tiles-pink.png"),
	"floor_tiles_blue": preload("res://assets/ui/house/floor/Floor-tiles-blue.png"),
	"floor_tiles_yellow": preload("res://assets/ui/house/floor/Floor-tiles-yellow.png"),
	"floor_grass_light": preload("res://assets/ui/house/floor/Floor-grass-light.png"),
	"floor_grass_dark": preload("res://assets/ui/house/floor/Floor-grass-dark.png"),
	"floor_grass_magic": preload("res://assets/ui/house/floor/Floor-grass-magic.png"),
}

const FLOOR_PRICES = {
	"floor_basic_pink": 80,
	"floor_basic_blue": 80,
	"floor_basic_purple": 80,
	"floor_basic_turquoise": 80,
	"floor_basic": 60,
	"floor_wood_caramel": 120,
	"floor_vwood_caramel": 120,
	"floor_vwood_beige": 120,
	"floor_tiles_pink": 150,
	"floor_tiles_blue": 150,
	"floor_tiles_yellow": 150,
	"floor_grass_light": 100,
	"floor_grass_dark": 100,
	"floor_grass_magic": 180,
}

const WALLPAPER_TEXTURES = {
	"wp_stripes_pink": preload("res://assets/ui/house/background/Wallpaper-stripes-pink.png"),
	"wp_stripes_blue": preload("res://assets/ui/house/background/Wallpaper-stripes-blue.png"),
	"wp_stripes_purple": preload("res://assets/ui/house/background/Wallpaper-stripes-purple.png"),
	"wp_stripes_turquoise": preload("res://assets/ui/house/background/Wallpaper-stripes-turquoise.png"),
	"wp_stripes_green": preload("res://assets/ui/house/background/Wallpaper-stripes-green.png"),
	"wp_stripes_beige": preload("res://assets/ui/house/background/Wallpaper-stripes-beige.png"),
	"wp_vstripes": preload("res://assets/ui/house/background/Wallpaper-vstripes.png"),
	"wp_ducks_pink": preload("res://assets/ui/house/background/Wallpaper-ducks-pink.png"),
	"wp_ducks_blue": preload("res://assets/ui/house/background/Wallpaper-ducks-blue.png"),
	"wp_ducks_yellow": preload("res://assets/ui/house/background/Wallpaper-ducks-yellow.png"),
	"wp_wood_pink": preload("res://assets/ui/house/background/Wallpaper-wood-pink.png"),
	"wp_wood_blue": preload("res://assets/ui/house/background/Wallpaper-wood-blue.png"),
	"wp_wood_beige": preload("res://assets/ui/house/background/Wallpaper-wood-beige.png"),
	"wp_wood_burgundy": preload("res://assets/ui/house/background/Wallpaper-wood-burgundy.png"),
	"wp_wood_navy": preload("res://assets/ui/house/background/Wallpaper-wood-navy.png"),
	"wp_vwood_pink": preload("res://assets/ui/house/background/Wallpaper-vwood-pink.png"),
	"wp_vwood_blue": preload("res://assets/ui/house/background/Wallpaper-vwood-blue.png"),
	"wp_vwood_beige": preload("res://assets/ui/house/background/Wallpaper-vwood-beige.png"),
	"wp_vwood_burgundy": preload("res://assets/ui/house/background/Wallpaper-vwood-burgundy.png"),
	"wp_vwood_navy": preload("res://assets/ui/house/background/Wallpaper-vwood-navy.png"),
}

const WALLPAPER_PRICES = {
	"wp_stripes_pink": 100,
	"wp_stripes_blue": 100,
	"wp_stripes_purple": 100,
	"wp_stripes_turquoise": 100,
	"wp_stripes_green": 100,
	"wp_stripes_beige": 100,
	"wp_vstripes": 100,
	"wp_ducks_pink": 140,
	"wp_ducks_blue": 140,
	"wp_ducks_yellow": 140,
	"wp_wood_pink": 120,
	"wp_wood_blue": 120,
	"wp_wood_beige": 120,
	"wp_wood_burgundy": 120,
	"wp_wood_navy": 120,
	"wp_vwood_pink": 120,
	"wp_vwood_blue": 120,
	"wp_vwood_beige": 120,
	"wp_vwood_burgundy": 120,
	"wp_vwood_navy": 120,
}

# ── House Colors ─────────────────────────────────────────────────────────────

const HOUSE_COLORS = {
	"pastel_pink": Color("ffcddfff"),
	"pastel_purple": Color("d3c6ffff"),
	"pastel_blue": Color("bacfffff"),
	"pastel_turquoise": Color("abeaffff"),
	"pastel_green": Color("cef8daff"),
	"pastel_yellow": Color("f6ecc2ff"),
	"pastel_orange": Color("fbd0b6ff"),
	"light_brown": Color("cca886ff"),
	"light_gray": Color("c2c3c2ff"),
	"white": Color("f6f2f2ff"),
	"bright_pink": Color("db3a91ff"),
	"bright_purple": Color("7101ddff"),
	"bright_blue": Color("1b20ffff"),
	"bright_turquoise": Color("00afc1ff"),
	"bright_green": Color("94d452ff"),
	"bright_yellow": Color("ffe22eff"),
	"bright_orange": Color("f89835ff"),
	"medium_brown": Color("a86944ff"),
	"medium_gray": Color("86737dff"),
	"dark_pink": Color("440025ff"),
	"dark_purple": Color("33184cff"),
	"dark_blue": Color("252c68ff"),
	"dark_turquoise": Color("073a43ff"),
	"dark_green": Color("203116ff"),
	"dark_yellow": Color("644b00ff"),
	"dark_orange": Color("5a2a00ff"),
	"dark_brown": Color("351c0cff"),
	"dark_gray": Color("332a2cff"),
	"black": Color("080606ff"),
}

var current_category: String = Global.TYPE_FURNITURE

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and visible:
		visible = false
		Global.shop_open = false

func _ready() -> void:
	Global.money_label = $Panel/MoneyBox/MoneyLabel
	Global.update_money(0)
	$TextureButton.pressed.connect(func(): visible = false; Global.shop_open = false)
	$Panel/Sidebar/Cat1.pressed.connect(func(): _set_category(Global.TYPE_FURNITURE))
	$Panel/Sidebar/Cat2.pressed.connect(func(): _set_category(Global.TYPE_WALLPAPER))
	$Panel/Sidebar/Cat3.pressed.connect(func(): _set_category(Global.TYPE_FLOOR))
	$Panel/Sidebar/Cat4.pressed.connect(func(): _set_category(Global.TYPE_HOUSE_COLOR))
	_populate_grid(current_category)


func _set_category(cat: String) -> void:
	current_category = cat
	_populate_grid(cat)

func _populate_grid(cat: String) -> void:
	var grid = $Panel/CenterContainer/VBoxContainer/ScrollContainer/GridMargin/GridContainer
	for child in grid.get_children():
		child.queue_free()
	grid.columns = 3

	match cat:
		Global.TYPE_FURNITURE:
			for item_name in ITEMS:
				var card = ShopCard.instantiate()
				grid.add_child(card)
				var atlas = AtlasTexture.new()
				atlas.atlas = FURNITURE
				atlas.region = TEXTURES[item_name]
				card.setup(item_name, PRICES[item_name], atlas)
				card.buy_pressed.connect(_on_item_pressed)

		Global.TYPE_FLOOR:
			for item_name in FLOOR_TEXTURES:
				var card = ShopCard.instantiate()
				grid.add_child(card)
				var atlas = AtlasTexture.new()
				atlas.atlas = FLOOR_TEXTURES[item_name]
				atlas.region = Rect2(0, 0, 70, 15)
				card.setup(item_name, FLOOR_PRICES[item_name], atlas, TextureRect.STRETCH_KEEP_CENTERED)
				card.buy_pressed.connect(_on_item_pressed)

		Global.TYPE_WALLPAPER:
			for item_name in WALLPAPER_TEXTURES:
				var card = ShopCard.instantiate()
				grid.add_child(card)
				var atlas = AtlasTexture.new()
				atlas.atlas = WALLPAPER_TEXTURES[item_name]
				atlas.region = Rect2(0, 0, 60, 50)
				card.setup(item_name, WALLPAPER_PRICES[item_name], atlas, TextureRect.STRETCH_KEEP_CENTERED)
				card.buy_pressed.connect(_on_item_pressed)

		Global.TYPE_HOUSE_COLOR:
			for item_name in HOUSE_COLORS:
				var card = ShopCard.instantiate()
				grid.add_child(card)
				var img = Image.create(32, 32, false, Image.FORMAT_RGB8)
				img.fill(HOUSE_COLORS[item_name])
				var tex = ImageTexture.create_from_image(img)
				card.setup(item_name, 5, tex, TextureRect.STRETCH_KEEP_CENTERED)
				card.buy_pressed.connect(_on_item_pressed)

func _on_item_pressed(item_name: String) -> void:
	var price = _get_price(item_name)

	if Global.has_money(price):
		Global.update_money(-price)

		match current_category:
			Global.TYPE_FURNITURE:
				var scene: PackedScene = ITEMS[item_name]
				Global.placing_item = scene
				Global.placing_type = Global.TYPE_FURNITURE
				if "/wall/" in scene.resource_path:
					Global.type_placing_item = "wall"
				elif "/floor/" in scene.resource_path:
					Global.type_placing_item = "floor"

			Global.TYPE_FLOOR:
				Global.placing_item = FLOOR_TEXTURES[item_name]
				Global.placing_type = Global.TYPE_FLOOR
				Global.placing_item_price = price

			Global.TYPE_WALLPAPER:
				Global.placing_item = WALLPAPER_TEXTURES[item_name]
				Global.placing_type = Global.TYPE_WALLPAPER
				Global.placing_item_price = price

			Global.TYPE_HOUSE_COLOR:
				Global.update_money(Global.current_house_color_price)
				Global.current_house_color_price = price
				Global.current_house_color = HOUSE_COLORS[item_name]
				RenderingServer.set_default_clear_color(HOUSE_COLORS[item_name])

		visible = false
		Global.shop_open = false
	else:
		_shake_money_box()

func _get_price(item_name: String) -> int:
	match current_category:
		Global.TYPE_FURNITURE: return PRICES[item_name]
		Global.TYPE_FLOOR:     return FLOOR_PRICES[item_name]
		Global.TYPE_WALLPAPER: return WALLPAPER_PRICES[item_name]
		Global.TYPE_HOUSE_COLOR: return 5
	return 0

func _shake_money_box() -> void:
	var money_box = $Panel/MoneyBox
	var label = $Panel/MoneyBox/MoneyLabel
	var origin = money_box.position

	label.add_theme_color_override("font_color", Color(0.976, 0.454, 0.417, 1.0))

	var tween = create_tween()
	for i in 3:
		tween.tween_property(money_box, "position", origin + Vector2(4, 0), 0.05)
		tween.tween_property(money_box, "position", origin + Vector2(-4, 0), 0.05)
	tween.tween_property(money_box, "position", origin, 0.04)
	tween.tween_callback(func(): label.remove_theme_color_override("font_color"))
