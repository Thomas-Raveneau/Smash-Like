extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 480

var linear_vel = Vector2()
var onair_time = 0
var on_floor = false

slave func set_pos_and_motion(p_pos, p_motion):
	position = p_pos
	linear_vel = p_motion

func _physics_process(delta):
	onair_time += delta

	# Apply Gravity
	linear_vel += delta * GRAVITY_VEC
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)

	if is_on_floor():
		onair_time = 0

	on_floor = onair_time < MIN_ONAIR_TIME

	if (is_network_master()):
	# Horizontal Movement
		var target_speed = 0
		if Input.is_action_pressed("move_left"):
			target_speed += -1
		if Input.is_action_pressed("move_right"):
			target_speed +=  1
	
		target_speed *= WALK_SPEED
		linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

		if on_floor and Input.is_action_just_pressed("jump"):
			linear_vel.y = -JUMP_SPEED
	
		rpc("set_pos_and_motion", position, linear_vel)
