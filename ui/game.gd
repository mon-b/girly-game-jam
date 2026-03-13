extends Node2D

var preview: Node2D = null

const FLOOR_Y1 = 324
const FLOOR_Y2 = 212
const WALL_TOP_Y = 150
const WALL_BOTTOM_Y = 255
const ROOM_X_MIN = 116
const ROOM_X_MAX = 524

func _ready():
	AudioManager.play_music("res://assets/audio/music/Dollhouse.mp3", 0)
	_restore_furniture()

func _process(_delta: float) -> void:
	
	if Global.placing_item != null and preview == null:
		preview = Global.placing_item.instantiate()
		preview.modulate.a = 0.5
		$House/Furniture.add_child(preview)

	if preview != null:
		var mouse = get_global_mouse_position()
		if Global.type_placing_item == "wall":
			var mid = (WALL_TOP_Y + WALL_BOTTOM_Y) / 2.0
			var wall_y
			if mouse.y < mid:
				wall_y = clamp(mouse.y, 140, FLOOR_Y2 - 10)
			else:
				wall_y = clamp(mouse.y, FLOOR_Y2 + 60, FLOOR_Y1 - 10)
			preview.position = Vector2(
				clamp(mouse.x, ROOM_X_MIN, ROOM_X_MAX),
				wall_y,
			)
		elif Global.type_placing_item == "floor":
			var floor_y
			if mouse.y > (FLOOR_Y1 + FLOOR_Y2)/2:
				floor_y = FLOOR_Y1
			else:
				floor_y = FLOOR_Y2
				
			preview.position = Vector2(clamp(mouse.x, ROOM_X_MIN, ROOM_X_MAX), floor_y)

func _unhandled_input(event: InputEvent) -> void:
	if Global.placing_item == null:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		preview.modulate.a = 1.0
		preview = null
		Global.placing_item = null

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		preview.queue_free()
		preview = null
		Global.placing_item = null

# ========================
# Handle door button press
# ========================

func _save_furniture() -> void:
	Global.placed_furniture.clear()
	for item in $House/Furniture.get_children():
		Global.placed_furniture.append({
			"scene_path": item.scene_file_path,
			"position": item.position
		})

func _restore_furniture() -> void:
	for data in Global.placed_furniture:
		var scene = load(data["scene_path"])
		if scene:
			var item = scene.instantiate()
			item.position = data["position"]
			$House/Furniture.add_child(item)

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
	# ----
	"db3a91ff", # bright pink
	"7101ddff", # bright purple
	"1b20ffff", # bright blue
	"00afc1ff", # bright turquoise
	"94d452ff", # bright green
	"ffe22eff", # bright yellow
	"f89835ff", # bright orange
	"a86944ff", # medium brown
	"86737dff", # medium gray
	# ----
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
	if curr_color_index == bg_colors.size()-1:
		curr_color_index = 0
	elif bg_colors.size() > 1:
		curr_color_index += 1

	RenderingServer.set_default_clear_color(Color(bg_colors[curr_color_index]))
