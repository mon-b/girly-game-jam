extends Node2D

var preview: Node2D = null

func _process(_delta: float) -> void:
	if Global.placing_item != null and preview == null:
		preview = Global.placing_item.instantiate()
		preview.modulate.a = 0.5
		add_child(preview)

	if preview != null:
		preview.position = get_global_mouse_position()

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
