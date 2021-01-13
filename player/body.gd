extends KinematicBody

signal send_height(height)

const GRAVITY = 40

const JUMP_POWER = 20
const AIR_ACCEL = 1
const NORMAL_ACCEL = 6
const MAX_SLOPE_ANGLE = 80
const CROUCH = 1.75
const NORM_SPEED = 20

var h_accel = 6

var move_speed = 20
var velocity = Vector3()
var direction = Vector3()
var movement = Vector3()
var h_velocity = Vector3()
var snap = Vector3()
var gravity_vec = Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	

		
	h_velocity = h_velocity.linear_interpolate(direction * move_speed, h_accel * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * GRAVITY * delta
		h_accel = AIR_ACCEL
	else:
		gravity_vec = -get_floor_normal()
		snap = -get_floor_normal()
		h_accel = NORMAL_ACCEL
		
		
	if is_on_ceiling():
		gravity_vec.y = -0.1


func _on_Player_send_height(height):
	emit_signal("send_height", height)


func _on_Player_direction_changed(d):
	direction = d


func _on_Player_jump():
	if is_on_floor():
		gravity_vec = Vector3.UP * JUMP_POWER
		snap = Vector3(0, 0, 0)
		
