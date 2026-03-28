extends Node2D

var current_floor_texture: Texture2D = null
var current_floor_price: int = 0
var current_wallpaper_texture: Texture2D = null
var current_wallpaper_price: int = 0

func _ready() -> void:
	current_floor_texture = $Floor.texture
	current_wallpaper_texture = $Wallpaper.texture

	$Floor.mouse_entered.connect(_on_floor_entered)
	$Floor.mouse_exited.connect(_on_floor_exited)
	$Floor.gui_input.connect(_on_floor_input)

	$Wallpaper.mouse_entered.connect(_on_wallpaper_entered)
	$Wallpaper.mouse_exited.connect(_on_wallpaper_exited)
	$Wallpaper.gui_input.connect(_on_wallpaper_input)

func _on_floor_entered() -> void:
	if Global.placing_type == Global.TYPE_FLOOR:
		$Floor.texture = Global.placing_item

func _on_floor_exited() -> void:
	if Global.placing_type == Global.TYPE_FLOOR:
		$Floor.texture = current_floor_texture

func _on_floor_input(event: InputEvent) -> void:
	if Global.placing_type != Global.TYPE_FLOOR:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Global.update_money(current_floor_price)
		current_floor_texture = Global.placing_item
		current_floor_price = Global.placing_item_price
		$Floor.texture = current_floor_texture
		Global.placing_item = null
		Global.placing_type = ""
		Global.placing_item_price = 0

func _on_wallpaper_entered() -> void:
	if Global.placing_type == Global.TYPE_WALLPAPER:
		$Wallpaper.texture = Global.placing_item

func _on_wallpaper_exited() -> void:
	if Global.placing_type == Global.TYPE_WALLPAPER:
		$Wallpaper.texture = current_wallpaper_texture

func _on_wallpaper_input(event: InputEvent) -> void:
	if Global.placing_type != Global.TYPE_WALLPAPER:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Global.update_money(current_wallpaper_price)
		current_wallpaper_texture = Global.placing_item
		current_wallpaper_price = Global.placing_item_price
		$Wallpaper.texture = current_wallpaper_texture
		Global.placing_item = null
		Global.placing_type = ""
		Global.placing_item_price = 0

func get_state() -> Dictionary:
	return {
		"floor_path": current_floor_texture.resource_path if current_floor_texture else "",
		"floor_price": current_floor_price,
		"wallpaper_path": current_wallpaper_texture.resource_path if current_wallpaper_texture else "",
		"wallpaper_price": current_wallpaper_price,
	}

func set_state(data: Dictionary) -> void:
	if data.floor_path != "":
		current_floor_texture = load(data.floor_path)
		$Floor.texture = current_floor_texture
	current_floor_price = data.floor_price
	if data.wallpaper_path != "":
		current_wallpaper_texture = load(data.wallpaper_path)
		$Wallpaper.texture = current_wallpaper_texture
	current_wallpaper_price = data.wallpaper_price
