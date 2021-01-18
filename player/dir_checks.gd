extends Spatial

const WAIT_TIME = 0.01
var wait_time = WAIT_TIME

var cast_dist = 1.5
var offset = 0.01
var direction = Vector3(0, 0, 0)

signal can_step()

onready var head_check = $HeadCheck
onready var body_check = $BodyCheck
onready var feet_check = $FeetCheck

export (NodePath) var TargetPath

onready var TargetNode = get_node(TargetPath)
onready var StartOffset = self.transform.origin - TargetNode.transform.origin

var collider
var collider_shape
var collider_points
var nearest_point

func _physics_process(delta):
	self.transform.origin = TargetNode.transform.origin + StartOffset
	
	head_check.cast_to = Vector3(direction.x*cast_dist, 0, direction.z*cast_dist)
	body_check.cast_to = Vector3(direction.x*cast_dist, 0, direction.z*cast_dist)
	feet_check.cast_to = Vector3(direction.x*cast_dist, 0, direction.z*cast_dist)
	
	if not head_check.is_colliding() and not body_check.is_colliding() and feet_check.is_colliding():
		wait_time -= delta
		if wait_time < 0:
			emit_signal("can_step")
			wait_time = WAIT_TIME
	

func _on_Player_direction_changed(d):
	direction = d

func _on_Body_send_height(height):
	head_check.translation.y = height
	body_check.translation.y = -height + height/1.5
	feet_check.translation.y = -height + 0.1
