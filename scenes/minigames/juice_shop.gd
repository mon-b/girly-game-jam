extends Node2D

# ========================
# Set up cup positions and colors
# ========================

enum CupPosition {
	TRASH,
	PUMP_YELLOW,
	PUMP_PINK,
	PUMP_BLUE,
	DELIVERY
}

enum JuiceColor {
	EMPTY,
	YELLOW,
	PINK,
	BLUE,
	ORANGE,
	PURPLE,
	GREEN
}

const Y_POSITION : float = 285.0

const X_POSITIONS: Array[float] = [
	125.0,
	216.0,
	296.0,
	376.0,
	473.0
]

const PUMP_COLORS: Array[JuiceColor] = [
	JuiceColor.EMPTY,
	JuiceColor.YELLOW,
	JuiceColor.PINK,
	JuiceColor.BLUE,
	JuiceColor.EMPTY
]

const RECIPES: Dictionary = {
	JuiceColor.YELLOW: [JuiceColor.YELLOW, JuiceColor.YELLOW],
	JuiceColor.PINK:   [JuiceColor.PINK, JuiceColor.PINK],
	JuiceColor.BLUE:   [JuiceColor.BLUE, JuiceColor.BLUE],
	JuiceColor.ORANGE: [JuiceColor.YELLOW, JuiceColor.PINK],
	JuiceColor.PURPLE: [JuiceColor.PINK, JuiceColor.BLUE],
	JuiceColor.GREEN:  [JuiceColor.YELLOW, JuiceColor.BLUE],
}

const COLOR_NAMES: Array[String] = [
	"empty", "yellow", "pink", "blue", "orange", "purple", "green"
]

# Keep track of trash door & delivery tray positions
var trash_door_start := Vector2(122.75, 310.5)
var delivery_tray_start := Vector2(473.0, 309.5)

# ========================
# Set & track state
# ========================

var current_order: JuiceColor = JuiceColor.YELLOW
var current_position: CupPosition = CupPosition.PUMP_PINK

var cup_visible: bool = true
var pump_history: Array[JuiceColor] = []

var score: int = 0
var time_left: float = 60.0

# ========================
# Node references
# ========================

@onready var cup_sprite: Sprite2D = $Cup
@onready var order_sprite: Sprite2D = $Order

@onready var score_label: Label = $Score
@onready var timer_label: Label = $Timer

@onready var liquid_streams: Array[Line2D] = [
	$LiquidYellow,
	$LiquidPink,
	$LiquidBlue
]

@onready var trash_door: Node2D = $TrashDoor
@onready var delivery_tray: Node2D = $DeliveryTray

@onready var score_modal = $ScoreModal
@onready var earnings_label = $ScoreModal/EarningsLabel
@onready var play_again = $ScoreModal/PlayAgain
@onready var leave_minigame = $ScoreModal/LeaveMinigame

# ========================
# On ready and while running
# ========================

func _ready():
	AudioManager.play_music("res://assets/audio/music/JuiceMinigame.mp3", 10)
	randomize()
	generate_new_order()
	update_cup_visuals()
	update_cup_position()
	update_ui()

func _process(delta):
	handle_timer(delta)
	handle_input()
	
# ========================
# Update timer & score
# ========================

func handle_timer(delta):
	if time_left > 0:
		time_left -= delta
		if time_left <= 0:
			time_left = 0
			game_over()
		update_ui()

func update_ui():
	# idk girl, the warning was pissing me off LOL
	@warning_ignore("integer_division")
	var minutes := int(time_left) / 60
	var seconds := int(time_left) % 60
	timer_label.text = "%d:%02d" % [minutes, seconds]
	score_label.text = str(score)

# ========================
# Handle input
# ========================

func handle_input():
	if Input.is_action_just_pressed("left"):
		move_cup(-1)
	elif Input.is_action_just_pressed("right"):
		move_cup(1)

	if Input.is_action_just_pressed("interact"):
		interact_at_current_position()

func move_cup(direction: int):
	if not cup_visible:
		return
	
	var new_index := clampi(current_position + direction, 0, 4)
	if new_index != current_position:
		current_position = new_index as CupPosition
		update_cup_position()

func update_cup_position():
	cup_sprite.position = Vector2(X_POSITIONS[current_position], Y_POSITION)
	check_trash_door()

var was_at_trash: bool = false

func check_trash_door():
	var at_trash := (current_position == CupPosition.TRASH)
	
	# Only animate when state changes
	if at_trash and not was_at_trash:
		# Arrived at trash - open door
		var tween := create_tween()
		tween.tween_property(trash_door, "position:x", trash_door_start.x - 50, 0.1)
		
	elif not at_trash and was_at_trash:
		# Left trash - close door
		var tween := create_tween()
		tween.tween_property(trash_door, "position:x", trash_door_start.x, 0.2)
	
	was_at_trash = at_trash

# ========================
# Texture path patterns + Load textures
# ========================

const CUP_TEXTURE_PATH := "res://assets/juice-shop/cup-%s.png"
const ORDER_TEXTURE_PATH := "res://assets/juice-shop/order-%s.png"

func load_texture(sprite: Sprite2D, path_template: String, color_name: String):
	var path := path_template % color_name
	var texture := load(path) as Texture2D
	if texture:
		sprite.texture = texture
	else:
		push_error("Failed to load: " + path)

func update_cup_visuals():
	if not cup_visible:
		cup_sprite.hide()
		return
	
	cup_sprite.show()
	
	var color_name: String
	var pump_count := pump_history.size()
	
	if pump_count == 0:
		color_name = "empty"
	elif pump_count == 1:
		color_name = COLOR_NAMES[pump_history[0]]
	else:
		color_name = COLOR_NAMES[calculate_mix()]
	
	load_texture(cup_sprite, CUP_TEXTURE_PATH, color_name)

# ========================
# Logic for mixing drinks
# ========================

func calculate_mix() -> JuiceColor:
	if pump_history.size() != 2:
		return JuiceColor.EMPTY
	
	var first := pump_history[0]
	var second := pump_history[1]
	
	for color in RECIPES.keys():
		var recipe: Array = RECIPES[color]
		if (first == recipe[0] and second == recipe[1]) or \
		   (first == recipe[1] and second == recipe[0]):
			return color
	
	return JuiceColor.EMPTY

func get_current_drink() -> JuiceColor:
	if pump_history.size() < 2:
		return JuiceColor.EMPTY
	return calculate_mix()

# ========================
# Gameplay interactions
# ========================

func interact_at_current_position():
	match current_position:
		CupPosition.TRASH:
			trash_cup()
			
		CupPosition.PUMP_YELLOW, CupPosition.PUMP_PINK, CupPosition.PUMP_BLUE:
			add_pump(PUMP_COLORS[current_position])
			
		CupPosition.DELIVERY:
			deliver_cup()

func add_pump(color: JuiceColor):
	if pump_history.size() >= 2:
		shake_cup()
		return
	
	animate_pump_stream(current_position)
	pump_history.append(color)
	update_cup_visuals()

func trash_cup():
	# Reset the cup
	pump_history.clear()
	current_position = CupPosition.PUMP_PINK
	update_cup_visuals()
	update_cup_position()

func deliver_cup():
	if pump_history.size() < 2:
		shake_cup()
		return
	
	# Parent cup to tray so it moves together
	var cup_global_pos = cup_sprite.global_position
	cup_sprite.get_parent().remove_child(cup_sprite)
	delivery_tray.add_child(cup_sprite)
	cup_sprite.global_position = cup_global_pos
	
	# Slide tray right with the cup on it
	var tween := create_tween()
	tween.tween_property(delivery_tray, "position:x", delivery_tray_start.x + 100, 0.2)
	await tween.finished
	
	# Update score
	var drink := get_current_drink()
	if drink == current_order:
		score += 10
	else:
		score = max(0, score - 5)
	update_ui()
	
	# Hide cup
	cup_visible = false
	cup_sprite.hide()
	
	
	# Return tray (cup is hidden so it won't show)
	await get_tree().create_timer(0.1).timeout
	var return_tween := create_tween()
	return_tween.tween_property(delivery_tray, "position:x", delivery_tray_start.x, 0.2)
	await return_tween.finished
	
	# Return cup to main scene (still hidden)
	delivery_tray.remove_child(cup_sprite)
	self.add_child(cup_sprite)
	
	# Generate new order and reset
	generate_new_order()
	reset_cup_to_middle()

# Small animation to show when an action is invalid
# AKA when the cup doesnt have 2 pumps yet or when you try to add a third
func shake_cup():
	var start_x := cup_sprite.position.x
	var shake_amount := 4.0
	var shake_duration := 0.05
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# Random shake animation
	tween.tween_property(cup_sprite, "position:x", start_x - shake_amount, shake_duration)
	tween.tween_property(cup_sprite, "position:x", start_x + shake_amount, shake_duration)
	tween.tween_property(cup_sprite, "position:x", start_x - shake_amount, shake_duration)
	tween.tween_property(cup_sprite, "position:x", start_x + shake_amount, shake_duration)
	tween.tween_property(cup_sprite, "position:x", start_x, shake_duration)

func reset_cup_to_middle():
	pump_history.clear()
	current_position = CupPosition.PUMP_PINK
	cup_visible = true
	update_cup_visuals()
	update_cup_position()
	update_ui()

func generate_new_order():
	var orders := [JuiceColor.YELLOW, JuiceColor.PINK, JuiceColor.BLUE, 
				   JuiceColor.ORANGE, JuiceColor.PURPLE, JuiceColor.GREEN]
	current_order = orders[randi() % orders.size()]
	load_texture(order_sprite, ORDER_TEXTURE_PATH, COLOR_NAMES[current_order])

func game_over():
	AudioManager.stop_music()

	earnings_label.text = "Score: " + str(score) + "\nEarnings: " + str(score * 4)
	score_label.hide()
	score_modal.show()
	$ColorRect.show()
	$LeaveButton.hide()

	Global.update_money(score*4)

	set_process(false)

# ========================
# Liquid line animations
# ========================

# Setup all streams when the minigame is loaded (on ready)
func setup_streams():
	for i in range(3):
		var stream := liquid_streams[i]
		stream.clear_points()
		stream.add_point(Vector2(0, -49))
		stream.add_point(Vector2(0, -28))
		stream.hide()

func animate_pump_stream(pump_pos: CupPosition):
	var stream_index := int(pump_pos) - 1
	if stream_index < 0 or stream_index >= 3:
		return
	
	var stream := liquid_streams[stream_index]
	
	stream.show()
	
	var tween := create_tween()
	tween.tween_property(stream, "width", 12.0, 0.1)
	tween.tween_property(stream, "width", 6.0, 0.1)
	
	await tween.finished
	await get_tree().create_timer(0.1).timeout
	var fade := create_tween()
	fade.tween_property(stream, "modulate:a", 0.0, 0.1)
	await fade.finished
	
	stream.hide()
	stream.modulate.a = 1.0
	stream.width = 6.0

# =========================
# Handle score modal buttons
# =========================

func _on_play_again_pressed():
	$ColorRect.hide()
	score_modal.hide()
	$LeaveButton.show()
	Global.change_scene("res://scenes/minigames/juice_shop.tscn")

func _on_leave_early_pressed():
	Global.update_money(score * 4)
	Global.change_scene("res://ui/menu.tscn")

func _on_leave_minigame_pressed():
	Global.change_scene("res://ui/menu.tscn")
