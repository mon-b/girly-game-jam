extends CharacterBody2D

@export var speed: int = 160

@export var floor_height: int = 112
@export var current_floor: int = 2

func _change_floor():
	pass

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	velocity.x = input_direction.x * speed
	velocity.y = 0
	
	if Input.is_action_just_pressed("up") and current_floor == 1:
		position.y -= floor_height
		current_floor = 2

	elif Input.is_action_just_pressed("down") and current_floor == 2:
		position.y += floor_height
		current_floor = 1


func _physics_process(delta):
	get_input()
	move_and_slide()
