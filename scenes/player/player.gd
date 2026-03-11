extends CharacterBody2D

@export var speed: int = 160

@export var floor_height: int = 112
@export var current_floor: int = 2

func _change_floor():
	if Input.is_action_just_pressed("up") and current_floor == 1:
		position.y -= floor_height
		current_floor = 2

	if Input.is_action_just_pressed("down") and current_floor == 2:
		position.y += floor_height
		current_floor = 1

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	velocity.x = input_direction.x * speed
	velocity.y = 0

func _physics_process(_delta):
	get_input()
	_change_floor()
	move_and_slide()
