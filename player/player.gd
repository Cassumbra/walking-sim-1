extends Spatial

const MOUSE_SENSITIVITY = 0.05

onready var body = $Body
onready var body_shape = $Body/BodyShape
onready var head = $Body/Head
onready var dir_checks = $DirChecks

var direction = Vector3()

signal direction_changed(direction)
signal send_height(height)
signal jump


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	emit_signal("send_height", body_shape.scale.y)
	

func _process(delta):
	get_input()

func _input(event):
	if event is InputEventMouseMotion:
		body.rotate_y(deg2rad(-event.relative.x * MOUSE_SENSITIVITY))
		head.rotate_x(deg2rad(-event.relative.y * MOUSE_SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)

func get_input():
	
	direction = Vector3(0, 0, 0)
	
	#I'm walkin here!
	if Input.is_action_pressed("movement_forward"):
		direction -= body.transform.basis.z
	elif Input.is_action_pressed("movement_backward"):
		direction += body.transform.basis.z
	if Input.is_action_pressed("movement_left"):
		direction -= body.transform.basis.x
	elif Input.is_action_pressed("movement_right"):
		direction += body.transform.basis.x
		
	direction = direction.normalized()
	
	emit_signal("direction_changed", direction)
	
	#Jumpy
	if Input.is_action_just_pressed("movement_jump"):
		emit_signal("jump")
		
	#Cursor Capture
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	if Input.is_action_just_pressed("interact_1"):
		pass
