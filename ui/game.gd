extends Node2D

const ItemToolbar = preload("res://scenes/furniture/item_toolbar.tscn")
const TEXTURE_EDIT = preload("res://assets/ui/Buttons-build.png")
const TEXTURE_CONFIRM = preload("res://assets/ui/Buttons-confirm.png")

@onready var tutorial_modal = $TutorialModal
@onready var fruit_bowl = $House/FruitBowl

var preview: Node2D = null
var item_dragged: Node2D = null
var drag_type: String = ""
var toolbar: Node2D = null
var selected_item: Node2D = null

const FLOOR_Y1 = 304
const FLOOR_Y2 = 192
const WALL_TOP_Y = 150
const WALL_BOTTOM_Y = 245
const ROOM_X_MIN = 116
const ROOM_X_MAX = 524

func _ready():
	AudioManager.play_music("res://assets/audio/music/Dollhouse.mp3", 0)
	_restore_furniture()
	if Global.tutorial_seen:
		tutorial_modal.hide()
	fruit_bowl.player = $House/Player
	fruit_bowl.pressed.connect(_on_door_pressed)

func _process(_delta: float) -> void:
	$VBoxContainer.visible = Global.placing_item == null and not Global.shop_open
	fruit_bowl.set_process_input(not Global.edit_mode and Global.placing_item == null)
	$VBoxContainer/Edit.texture_normal = TEXTURE_CONFIRM if Global.edit_mode else TEXTURE_EDIT
	for button in $VBoxContainer.get_children():
		if button.name == "Edit":
			continue
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE if Global.edit_mode else Control.MOUSE_FILTER_STOP

	if Global.placing_item != null and preview == null and Global.placing_type == Global.TYPE_FURNITURE:
			preview = Global.placing_item.instantiate()
			preview.modulate.a = 0.5
			$House/Furniture.add_child(preview)

	if preview != null:
		var mouse = get_global_mouse_position()
		var sprite = preview.get_node("Sprite2D")
		var half_w = sprite.region_rect.size.x / 2.0
		var x_min = ROOM_X_MIN + half_w + 4
		var x_max = ROOM_X_MAX - half_w - 4
		if Global.type_placing_item == "wall":
			var mid = (WALL_TOP_Y + WALL_BOTTOM_Y) / 2.0
			var wall_y
			if mouse.y < mid:
				wall_y = clamp(mouse.y, 140, FLOOR_Y2 - 10)
			else:
				wall_y = clamp(mouse.y, FLOOR_Y2 + 60, FLOOR_Y1 - 10)
			preview.position = Vector2(
				clamp(mouse.x, x_min, x_max),
				wall_y,
			)
		elif Global.type_placing_item == "floor":
			var half_h = sprite.region_rect.size.y / 2.0
			var floor_y
			if mouse.y > (FLOOR_Y1 + FLOOR_Y2)/2:
				floor_y = FLOOR_Y1 - half_h + 22
			else:
				floor_y = FLOOR_Y2 - half_h + 22

			preview.position = Vector2(clamp(mouse.x, x_min, x_max), floor_y)
	
	if item_dragged != null:
		var mouse = get_global_mouse_position()
		var sprite = item_dragged.get_node("Sprite2D")
		var sprite_w = sprite.region_rect.size.x if sprite.region_rect.size.x > 0 else sprite.texture.get_size().x
		var sprite_h = sprite.region_rect.size.y if sprite.region_rect.size.y > 0 else sprite.texture.get_size().y
		var half_w = sprite_w / 2.0
		var x_min = ROOM_X_MIN + half_w + 4
		var x_max = ROOM_X_MAX - half_w - 4
		if drag_type == "wall":
			var mid = (WALL_TOP_Y + WALL_BOTTOM_Y) / 2.0
			var wall_y
			if mouse.y < mid:
				wall_y = clamp(mouse.y, 140, FLOOR_Y2 - 10)
			else:
				wall_y = clamp(mouse.y, FLOOR_Y2 + 60, FLOOR_Y1 - 10)
			item_dragged.position = Vector2(
				clamp(mouse.x, x_min, x_max),
				wall_y,
			)
		elif drag_type == "floor":
			var half_h = sprite_h / 2.0
			var floor_y
			if mouse.y > (FLOOR_Y1 + FLOOR_Y2)/2:
				floor_y = FLOOR_Y1 - half_h + 22
			else:
				floor_y = FLOOR_Y2 - half_h + 22

			item_dragged.position = Vector2(clamp(mouse.x, x_min, x_max), floor_y)
			

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and Global.placing_item == null:
		if item_dragged != null:
			item_dragged.modulate.a = 1.0
			item_dragged = null
			drag_type = ""
			return

		if not Global.edit_mode:
			return

		var mouse = get_global_mouse_position()

		var fruit_sprite = fruit_bowl.get_node("Sprite2D")
		var fruit_size = fruit_sprite.texture.get_size()
		var fruit_rect = Rect2(fruit_bowl.position - fruit_size / 2.0, fruit_size)
		if fruit_rect.has_point(mouse):
			item_dragged = fruit_bowl
			drag_type = "floor"
			fruit_bowl.modulate.a = 0.7
			return

		var clicked_item = null
		for item in $House/Furniture.get_children():
			if item == preview:
				continue
			var size = item.get_node("Sprite2D").region_rect.size
			var rect = Rect2(item.position - size / 2, size)
			if rect.has_point(mouse):
				clicked_item = item
				break

		if clicked_item:
			_show_toolbar(clicked_item)
		else:
			_hide_toolbar()

	if Global.placing_item == null:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Global.placing_type == Global.TYPE_FURNITURE:
			preview.modulate.a = 1.0
			preview.set_meta("price", Global.placing_item_price)
			preview = null
			Global.placing_item = null
			Global.placing_type = ""

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if Global.placing_type == Global.TYPE_FURNITURE:
			preview.queue_free()
			preview = null
		else:
			Global.update_money(Global.placing_item_price)
		Global.placing_item = null
		Global.placing_type = ""

# ========================
# Handle door button press
# ========================

func _save_furniture() -> void:
	Global.fruit_bowl_position = fruit_bowl.position
	Global.placed_furniture.clear()
	for item in $House/Furniture.get_children():
		Global.placed_furniture.append({
			"scene_path": item.scene_file_path,
			"position": item.position,
			"price": item.get_meta("price", 0)
		})
	Global.room_states.clear()
	for room in [$House/Room1, $House/Room2, $House/Room3, $House/Room4]:
		Global.room_states.append(room.get_state())

func _restore_furniture() -> void:
	fruit_bowl.position = Global.fruit_bowl_position
	for data in Global.placed_furniture:
		var scene = load(data["scene_path"])
		if scene:
			var item = scene.instantiate()
			item.position = data["position"]
			item.set_meta("price", data.get("price", 0))
			$House/Furniture.add_child(item)
	var rooms = [$House/Room1, $House/Room2, $House/Room3, $House/Room4]
	for i in rooms.size():
		if i < Global.room_states.size():
			rooms[i].set_state(Global.room_states[i])

func _on_door_pressed():
	_save_furniture()
	Global.change_scene("res://scenes/minigames/juice_shop.tscn")

# ========================
# Take screenshot when clicking camera
# ========================

# Take a screenshot (((experimental still havent tested in browser)))
func take_screenshot(filename := "screenshot.png") -> void:
	await get_tree().process_frame
	
	var viewport = get_viewport()
	var img: Image = viewport.get_texture().get_image()
	
	var png_buffer = img.save_png_to_buffer()
	var base64 = Marshalls.raw_to_base64(png_buffer)
	var data_url = "data:image/png;base64," + base64
	
	if OS.has_feature("web"):
		# Only run JS in actual web build
		var safe_name = filename.replace("\"", "\\\"")
		var js = """
            (function() {
                var link = document.createElement('a');
                link.href = '%s';
                link.download = '%s';
                link.style.display = 'none';
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            })();
		""" % [data_url, safe_name]
		
		JavaScriptBridge.eval(js, true)  # true = show errors in console
	else:
		# Editor / desktop fallback: save to disk so you can see it worked
		var err = img.save_png("user://%s" % filename)
		if err == OK:
			print("Screenshot saved to: user://%s (open via Project → Open User Data Folder)" % filename)
		else:
			printerr("Failed to save PNG: ", err)

# If I didnt hide all buttons manually they wouldn't hide
func _on_camera_pressed():
	$VBoxContainer.hide()
	$VBoxContainer/Camera.hide()
	$VBoxContainer/Decorate.hide()
	$VBoxContainer/Shop.hide()
	$VBoxContainer/Door.hide()
	await get_tree().create_timer(0.1).timeout

	take_screenshot()

	await get_tree().create_timer(0.1).timeout
	$VBoxContainer.show()
	$VBoxContainer/Camera.show()
	$VBoxContainer/Decorate.show()
	$VBoxContainer/Shop.show()
	$VBoxContainer/Door.show()


# ========================
# Toggle BG color when clicking the color palette
# ========================

var bg_colors = [
	"ffcddfff", # pastel pink
	"d3c6ffff", # pastel purple
	"bacfffff", # pastel blue
	"abeaffff", # pastel turquoise
	"cef8daff", # pastel green
	"f6ecc2ff", # pastel yellow
	"fbd0b6ff", # pastel orange
	"cca886ff", # light brown
	"c2c3c2ff", # light gray
	"f6f2f2ff", # white
	"db3a91ff", # bright pink
	"7101ddff", # bright purple
	"1b20ffff", # bright blue
	"00afc1ff", # bright turquoise
	"94d452ff", # bright green
	"ffe22eff", # bright yellow
	"f89835ff", # bright orange
	"a86944ff", # medium brown
	"86737dff", # medium gray
	"440025ff", # dark pink
	"33184cff", # dark purple
	"252c68ff", # dark blue
	"073a43ff", # dark turquoise
	"203116ff", # dark green
	"644b00ff", # dark yellow
	"5a2a00ff", # dark orange
	"351c0cff", # dark brown
	"332a2cff", # dark gray
	"080606ff" # black
]

var curr_color_index = 0

func _on_decorate_pressed():
	Global.edit_mode = not Global.edit_mode
	if Global.edit_mode:
		_start_wiggle()
	else:
		_stop_wiggle()
		_hide_toolbar()

func _start_wiggle() -> void:
	var items = $House/Furniture.get_children() + [fruit_bowl]
	for item in items:
		if item == preview:
			continue
		var tween = create_tween().set_loops()
		tween.tween_property(item, "rotation_degrees", 2.0, 0.1)
		tween.tween_property(item, "rotation_degrees", -2.0, 0.1)
		item.set_meta("wiggle_tween", tween)

func _stop_wiggle() -> void:
	var items = $House/Furniture.get_children() + [fruit_bowl]
	for item in items:
		if item == preview:
			continue
		if item.has_meta("wiggle_tween"):
			item.get_meta("wiggle_tween").kill()
			item.remove_meta("wiggle_tween")
		item.rotation_degrees = 0.0

func _show_toolbar(item: Node2D) -> void:
	if toolbar == null:
		toolbar = ItemToolbar.instantiate()
		toolbar.move_pressed.connect(_on_toolbar_move)
		toolbar.delete_pressed.connect(_on_toolbar_delete)
		add_child(toolbar)
	if selected_item:
		selected_item.modulate = Color(1, 1, 1, 1)
	selected_item = item
	item.modulate = Color(1, 1, 1, 0.7)
	toolbar.setup(item)
	toolbar.show()

func _hide_toolbar() -> void:
	if selected_item:
		selected_item.modulate = Color(1, 1, 1, 1)
		selected_item = null
	if toolbar:
		toolbar.hide()

func _on_toolbar_move(item: Node2D) -> void:
	_hide_toolbar()
	item_dragged = item
	if "wall" in item.scene_file_path:
		drag_type = "wall"
	elif "floor" in item.scene_file_path:
		drag_type = "floor"
	item.modulate.a = 0.7

func _on_toolbar_delete(item: Node2D) -> void:
	Global.update_money(item.get_meta("price", 0))
	if item.has_meta("wiggle_tween"):
		item.get_meta("wiggle_tween").kill()
	_hide_toolbar()
	item.queue_free()


func _on_tutorial_pressed():
	tutorial_modal.show()

func _on_close_tutorial_pressed():
	Global.tutorial_seen = true
	tutorial_modal.hide()
