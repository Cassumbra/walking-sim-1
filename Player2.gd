extends KinematicBody

const GRAVITY = 9.81

const JUMP_POWER = 5
const MOVE_SPEED = 20

var velocity = Vector3()
var direction = Vector3()

const MAX_SLOPE_ANGLE = 80

var camera
var rotation_helper
export var MOUSE_SENSITIVY = 0.05

func _ready():
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	#Input
	#Walking
	direction = Vector3()
	var cam_xform =  camera.get_global_transform()
	
	var input_movement_vector = Vector2()
	
	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	
	#I'm not normalizing because I think "bugs" are fun
	
	direction += -cam_xform.basis.z * input_movement_vector.y
	direction += cam_xform.basis.x * input_movement_vector.x

	#Cursor Capture
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#Processing
	direction.y = 0
	
	#Jumping
	if is_on_floor():
		velocity.y = -0.01
		if Input.is_action_just_pressed("movement_jump"):
			velocity.y += JUMP_POWER
	elif not is_on_floor():
		velocity.y -= delta * GRAVITY

	velocity.x = MOVE_SPEED * direction.x
	velocity.z = MOVE_SPEED * direction.z
	
	velocity = move_and_slide(velocity, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

	
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVY * -1))
		
		var camera_rotation  =  rotation_helper.rotation_degrees
		camera_rotation.x = clamp(camera_rotation.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rotation
