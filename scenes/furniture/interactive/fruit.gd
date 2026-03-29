extends Node2D

signal pressed

@onready var sprite: Sprite2D = $Sprite2D

var normal_texture = preload("res://assets/ui/house/interactive_items/Furniture-fruit.png")
var hover_texture = preload("res://assets/ui/house/interactive_items/Furniture-fruit-hover.png")

const INTERACT_RADIUS = 40.0
var player: Node2D = null
var hovered := false

func _input(event: InputEvent) -> void:
	var tex_size = sprite.texture.get_size()
	var sprite_rect = Rect2(global_position - tex_size / 2.0, tex_size)

	if event is InputEventMouseMotion:
		hovered = sprite_rect.has_point(get_global_mouse_position())
		sprite.texture = hover_texture if hovered else normal_texture

	if event is InputEventKey and event.keycode == KEY_E and event.pressed and not event.echo:
		var player_near = player != null and player.global_position.distance_to(global_position) <= INTERACT_RADIUS
		if hovered and player_near:
			pressed.emit()
