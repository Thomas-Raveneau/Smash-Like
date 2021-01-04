extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 480
const SIDING_CHANGE_SPEED = 10

var linear_vel = Vector2()
var onair_time = 0
var on_floor = false
var attacking = false

onready var sprite = $AnimatedSprite
var anim = ""
puppet var slave_anim = "Idle"

func _ready():
	pass

puppet func set_pos_and_motion(p_pos, p_motion):
	position = p_pos
	linear_vel = p_motion
	
sync func attack():
	if attacking == true:
		return
	attacking = true
	anim = "Attack"
	sprite.play(anim)

func is_attack_finished():
	if sprite.animation == "Attack" and sprite.frame + 1 == sprite.frames.get_frame_count("Attack"):
		attacking = false

func player_animations():
	if attacking == true:
		return

	var new_anim = "Idle"
	
	if linear_vel.x < -SIDING_CHANGE_SPEED:
		sprite.flip_h = true
		new_anim = "Run"

	if linear_vel.x > SIDING_CHANGE_SPEED:
		sprite.flip_h = false
		new_anim = "Run"

	if !on_floor:
		if linear_vel.y < 0:
			new_anim = "Jump"
		else:
				new_anim = "Fall"
	
	if new_anim != anim:
		anim = new_anim
		sprite.play(anim)

func _physics_process(delta):
	onair_time += delta

	# Apply Gravity
	linear_vel += delta * GRAVITY_VEC
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)

	if is_on_floor():
		onair_time = 0

	on_floor = onair_time < MIN_ONAIR_TIME

	if (is_network_master()):
		var target_speed = 0
		if Input.is_action_pressed("move_left"):
			target_speed += -1
		if Input.is_action_pressed("move_right"):
			target_speed +=  1
		
		target_speed *= WALK_SPEED
		linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

		if on_floor and Input.is_action_just_pressed("jump"):
			linear_vel.y = -JUMP_SPEED
			
		if Input.is_action_just_pressed("attack"):
			rpc("attack")
	
		rpc_unreliable("set_pos_and_motion", position, linear_vel)
	if (attacking == true):
		is_attack_finished()
	player_animations()
	
