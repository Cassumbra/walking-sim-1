extends Spatial

var cast_dist = 1.5
var offset = 0.01

signal can_step(y_displace)

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

func _process(_delta):
	self.transform.origin = TargetNode.transform.origin + StartOffset


func _on_Player_direction_changed(direction):
	head_check.cast_to = Vector3(direction.x*cast_dist, 0, direction.z*cast_dist)
	body_check.cast_to = Vector3(direction.x*cast_dist, 0, direction.z*cast_dist)
	feet_check.cast_to = Vector3(direction.x*cast_dist, 0, direction.z*cast_dist)
	
	if (not head_check.is_colliding()) and (not body_check.is_colliding()) and (feet_check.is_colliding()):
		collider = feet_check.get_collider()
		collider_shape = feet_check.get_collider_shape()
		#print(str(body_check.global_transform.origin))
		if collider.shape_owner_get_owner(collider_shape).shape.has_method("get_points"):
			collider_points = collider.shape_owner_get_owner(collider_shape).shape.get_points()
			nearest_point = collider_points[0]
			for point in collider_points:
				if point.distance_to(body_check.global_transform.origin + body_check.cast_to) < nearest_point.distance_to(body_check.global_transform.origin):
					nearest_point = point
			if nearest_point.y < body_check.global_transform.origin.y:
				emit_signal("can_step", body_check.global_transform.origin.y - nearest_point.y)

func _on_Body_send_height(height):
	head_check.translation.y = height
	body_check.translation.y = -height + height/1.5
	feet_check.translation.y = -height
