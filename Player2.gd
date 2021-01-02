extends KinematicBody

const GRAVITY = 9.81

const JUMP_POWER = 7
const MOVE_SPEED = 5.5
const AIR_MOVE_SPEED = 15
const AIR_ACCEL = 1
const NORMAL_ACCEL = 6
const MAX_SLOPE_ANGLE = 80

var h_accel = 6

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
	
	if Input.is_action_pressed("movement_forward"):
		direction += transform.basis.z
	elif Input.is_action_pressed("movement_backward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("movement_left"):
		direction += transform.basis.x
	elif Input.is_action_pressed("movement_right"):
		direction -= transform.basis.x

	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * MOVE_SPEED, h_accel * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	
	if is_on_wall(): #and direction != Vector3(0, 0, 0):
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if collision.normal.y != 1:
				head_check.cast_to = Vector3(movement.x/2, 0, movement.z/2)
				body_check.cast_to = Vector3(movement.x/2, 0, movement.z/2)
				foot_check.cast_to = Vector3(movement.x/2, 0, movement.z/2)
				print(str(head_check.is_colliding()) + "\n" + str(body_check.is_colliding()) + "\n" + str(foot_check.get_collision_point()))
				if  (not head_check.is_colliding()) and (not body_check.is_colliding()) and (foot_check.is_colliding()):
					label.set_text("Steppy!")
					move_and_collide(Vector3(0, JUMP_POWER, 0))
					move_and_collide(Vector3(movement.x/10, -JUMP_POWER, movement.z/10))
	else:
		label.set_text("")
	
	if direction != Vector3(0, 0, 0):
		move_and_slide_with_snap(movement * MOVE_SPEED, snap, Vector3.UP)
		snap = Vector3.DOWN
	else:
		move_and_slide(movement * MOVE_SPEED, Vector3.UP)
	
	#Cursor Capture
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


#Old stuffs

#func _ready():
#	camera = $head/Camera
#	head = $Head
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#
#func _physics_process(delta):
#	#Input
#	#Walking
#	direction = Vector3()
#	var cam_xform =  camera.get_global_transform()
#
#	var input_movement_vector = Vector2()
#
#	if Input.is_action_pressed("movement_forward"):
#		input_movement_vector.y += 1
#	if Input.is_action_pressed("movement_backward"):
#		input_movement_vector.y -= 1
#	if Input.is_action_pressed("movement_right"):
#		input_movement_vector.x += 1
#	if Input.is_action_pressed("movement_left"):
#		input_movement_vector.x -= 1
#
#	#I'm not normalizing because I think "bugs" are fun
#
#	direction += -cam_xform.basis.z * input_movement_vector.y
#	direction += cam_xform.basis.x * input_movement_vector.x
#
#	#Cursor Capture
#	if Input.is_action_just_pressed("ui_cancel"):
#		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
#			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#		else:
#			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#
#	#Processing
#	direction.y = 0
#
#	#Jumping
#	if is_on_floor():
#		velocity.y = -0.01
#		#Walking
#		velocity.x = MOVE_SPEED * direction.x
#		velocity.z = MOVE_SPEED * direction.z
#		if Input.is_action_just_pressed("movement_jump"):
#			velocity.y += JUMP_POWER
#	elif not is_on_floor():
#		velocity.y -= delta * GRAVITY
#		#Air Strafing
#		velocity.x = AIR_MOVE_SPEED * direction.x
#		velocity.z = AIR_MOVE_SPEED * direction.z
#
#
#
#	var horizontal_velocity = velocity
#	horizontal_velocity.y = 0
#
#	velocity = move_and_slide(velocity, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
#
#
#func _input(event):
#	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#		head.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVY))
#		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVY * -1))
#
#		var camera_rotation  =  head.rotation_degrees
#		camera_rotation.x = clamp(camera_rotation.x, -70, 70)
#		head.rotation_degrees = camera_rotation



