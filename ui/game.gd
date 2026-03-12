extends Node2D

var preview: Node2D = null

const FLOOR_Y = 333
const WALL_Y_MIN = 120
const WALL_Y_MAX = 215
const ROOM_X_MIN = 116
const ROOM_X_MAX = 524


func _process(_delta: float) -> void:
	
	if Global.placing_item != null and preview == null:
		preview = Global.placing_item.instantiate()
		preview.modulate.a = 0.5
		add_child(preview)

	if preview != null:
		var mouse = get_global_mouse_position()
		if Global.type_placing_item == "wall":
			preview.position = Vector2(
				clamp(mouse.x, ROOM_X_MIN, ROOM_X_MAX),
				clamp(mouse.x, WALL_Y_MIN, WALL_Y_MAX),
			)
		elif Global.type_placing_item == "wall":
			preview.position = Vector2(clamp(mouse.x, ROOM_X_MIN, ROOM_X_MAX), FLOOR_Y)

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
