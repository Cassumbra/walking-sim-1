extends Spatial

const MOUSE_SENSITIVITY = 0.20

onready var body = $Body
onready var body_shape = $Body/BodyShape
onready var head = $Body/Head
onready var dir_checks = $DirChecks

var direction = Vector3()

signal direction_changed(direction)
signal crouch
signal uncrouch
signal jump

signal look_object(object, interact)


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.load_player(get_tree().get_root().get_node("World/Player"))
	

func _process(_delta):
	get_input()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
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
	if Input.is_action_just_pressed("movement_jump") and not Input.is_action_pressed("movement_crouch"):
		emit_signal("jump")
		
	#Crouchy
	if Input.is_action_just_pressed("movement_crouch"):
		emit_signal("crouch")
	elif Input.is_action_just_released("movement_crouch"):
		emit_signal("uncrouch")
		
	#Cursor Capture
	if Input.is_action_just_pressed("ui_switch"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	#Close window
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
			


func _on_Head_look_object(object):
	if Input.is_action_just_pressed("interact_1"):
		emit_signal("look_object", object, true)
	else:
		emit_signal("look_object", object, false)
