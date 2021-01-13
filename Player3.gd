extends KinematicBody

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

var full_contact = false
var can_step = false

var camera
onready var head = $Head
onready var ground_check = $GroundCheck
onready var body = $Body
onready var label = get_node("../HUD/Crosshair/Label")
onready var label2 = get_node("../HUD/Crosshair/Label2")

onready var head_check = get_node("../H_Checks/HeadCheck")
onready var body_check = get_node("../H_Checks/BodyCheck")
onready var foot_check = get_node("../H_Checks/FootCheck")

export var MOUSE_SENSITIVY = 0.05

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * MOUSE_SENSITIVY))
		head.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVY))
		head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)

func _physics_process(delta):
	direction = Vector3()
	
	full_contact = ground_check.is_colliding()
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * GRAVITY * delta
		h_accel = AIR_ACCEL
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * GRAVITY
		h_accel = NORMAL_ACCEL
	else:
		gravity_vec = -get_floor_normal()
		h_accel = NORMAL_ACCEL
		
	if Input.is_action_just_pressed("movement_jump") and (is_on_floor() or full_contact):
		gravity_vec = Vector3.UP * JUMP_POWER
		snap = Vector3(0, 0, 0)
		
	if Input.is_action_just_pressed("movement_crouch"):
		body.scale.y -= CROUCH
		head.translation.y += -CROUCH - 0.1
		move_speed = NORM_SPEED / 2
		
		head_check.translation.y = body.scale.y
		body_check.translation.y = (body.scale.y / 2) -0.5
		foot_check.translation.y = -body.scale.y
	elif Input.is_action_just_released("movement_crouch"):
		body.scale = Vector3(1, 3, 1)
		head.translation = Vector3(0, 2, 0)
		move_speed = NORM_SPEED
	
		head_check.translation.y = body.scale.y
		body_check.translation.y = (body.scale.y / 2) -0.5
		foot_check.translation.y = -body.scale.y
		
	
	if Input.is_action_pressed("movement_forward"):
		direction += transform.basis.z
	elif Input.is_action_pressed("movement_backward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("movement_left"):
		direction += transform.basis.x
	elif Input.is_action_pressed("movement_right"):
		direction -= transform.basis.x

	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * move_speed, h_accel * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	#Stairs!
	if is_on_wall():
		if is_on_floor():
			for i in range(get_slide_count()):
				var collision = get_slide_collision(i)
				if collision.normal.y != 1:
					head_check.cast_to = Vector3(direction.x*1.5, 0, direction.z*1.5)
					body_check.cast_to = Vector3(direction.x*1.5, 0, direction.z*1.5)
					foot_check.cast_to = Vector3(direction.x*1.5, 0, direction.z*1.5)
					if (not head_check.is_colliding()) and (not body_check.is_colliding()) and (foot_check.is_colliding()):
						move_and_collide(Vector3(0, JUMP_POWER, 0))
						move_and_collide(Vector3(movement.x/100, -JUMP_POWER, movement.z/100))
		#else:
		#	h_velocity.x = 0
		#	h_velocity.z = 0
	
	if is_on_ceiling():
		gravity_vec.y = -0.1
		move_and_collide(Vector3(0, gravity_vec.y, 0))
	
	if direction != Vector3(0, 0, 0) and (not is_on_ceiling()):
		move_and_slide_with_snap(movement, snap, Vector3.UP)
		snap = Vector3.DOWN
	else:
		move_and_slide(movement, Vector3.UP)
	
	#Cursor Capture
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
