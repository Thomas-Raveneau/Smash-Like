extends KinematicBody2D

export (int) var SPEED = 400
export (int) var JUMP_FORCE = -1800
export (int) var GRAVITY = 4000

var velocity = Vector2.ZERO

remote func _set_position(pos):
	global_position = pos

func _physics_process(delta):
	velocity = Vector2()

	if Input.is_action_pressed("move_right"):
		velocity.x += SPEED
	if Input.is_action_pressed("move_left"):
		velocity.x -= SPEED
	
#	velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_FORCE
	
	if velocity != Vector2():
		if is_network_master():
			velocity = move_and_slide(velocity, Vector2.UP)
		rpc_unreliable("_set_position", global_position)
