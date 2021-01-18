extends KinematicBody

signal send_height(height)

const GRAVITY = 70

const JUMP_POWER = 25
const AIR_ACCEL = 1
const NORMAL_ACCEL = 6
const MAX_SLOPE_ANGLE = 80
const CROUCH = 1.75
const NORM_SPEED = 15
const NORM_HEIGHT = 3
const STEP_POWER = 5

var h_accel = 6

var move_speed = NORM_SPEED
var velocity = Vector3()
var direction = Vector3()
var movement = Vector3()
var h_velocity = Vector3()
var snap = Vector3()
var gravity_vec = Vector3()

const NORM_JUMP_QUEUE = 0.1
var jump_queue = NORM_JUMP_QUEUE
var jump = false

onready var body_shape = $BodyShape


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().root, "ready")
	emit_signal("send_height", body_shape.scale.y)


func _process(delta):
	if jump:
		if is_on_floor():
			#move_speed = move_speed * 2
			gravity_vec = Vector3.UP * JUMP_POWER
			snap = Vector3(0, 0, 0)
		if jump_queue <= 0:
			jump = false
		jump_queue -= delta
		

	#move_speed = lerp(move_speed, NORM_SPEED, h_accel * delta)
	
	h_velocity = h_velocity.linear_interpolate(direction * move_speed, h_accel * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	move_and_slide_with_snap(movement, snap, Vector3.UP, false, 4, PI/4)
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * GRAVITY * delta
		h_accel = AIR_ACCEL
	else:
		gravity_vec = -get_floor_normal()
		snap = -get_floor_normal()
		h_accel = NORMAL_ACCEL
		
	if is_on_ceiling():
		gravity_vec.y = -0.1
		


func _on_Player_direction_changed(d):
	direction = d


func _on_Player_jump():
	jump = true
	jump_queue = NORM_JUMP_QUEUE

		
#Add move_and_collide offset when crouching and uncrouching to prevent collision bugs
func _on_Player_crouch():
	move_speed = NORM_SPEED / 3.5
	body_shape.scale.y = NORM_HEIGHT / 1.5
	if is_on_floor(): move_and_collide(Vector3(0, -body_shape.scale.y, 0))
	emit_signal("send_height", body_shape.scale.y)


#Add move_and_collide offset when crouching and uncrouching to prevent collision bugs
func _on_Player_uncrouch():
	move_speed = NORM_SPEED
	body_shape.scale.y = NORM_HEIGHT
	if is_on_floor(): move_and_collide(Vector3(0, body_shape.scale.y/3, 0))
	emit_signal("send_height", body_shape.scale.y)


func _on_DirChecks_can_step(y_displace):
	if is_on_wall() and is_on_floor():
		#print(str(y_displace))
		move_and_collide(Vector3(0, y_displace-0.1, 0))
		#move_and_collide(Vector3(direction.x/100, 0, direction.z/100))
		

