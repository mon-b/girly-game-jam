extends Node2D

signal move_pressed(item)
signal delete_pressed(item)

var target_item: Node2D = null

func _ready() -> void:
	$MoveButton.pressed.connect(func(): move_pressed.emit(target_item))
	$DeleteButton.pressed.connect(func(): delete_pressed.emit(target_item))

func setup(item: Node2D) -> void:
	target_item = item
	var half_h = item.get_node("Sprite2D").region_rect.size.y / 2.0
	global_position = item.global_position + Vector2(0, -half_h - 16)
