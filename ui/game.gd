extends Node2D

var preview: Node2D = null

const FLOOR_Y1 = 305
const FLOOR_Y2 = 193
const WALL_TOP_Y = 150
const WALL_BOTTOM_Y = 255
const ROOM_X_MIN = 116
const ROOM_X_MAX = 524


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


func _on_door_pressed():
	Global.change_scene("res://scenes/minigames/juice_shop.tscn")
