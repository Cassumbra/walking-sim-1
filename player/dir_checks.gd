extends Spatial

var cast_dist = 1


onready var head_check = $HeadCheck
onready var body_check = $BodyCheck
onready var feet_check = $FeetCheck

export (NodePath) var TargetPath

onready var TargetNode = get_node(TargetPath)
onready var StartOffset = self.transform.origin - TargetNode.transform.origin

#i need to tell player what my raycasts are hitting

func _ready():
	pass 


func _process(delta):
	self.transform.origin = TargetNode.transform.origin + StartOffset


func _on_Player_direction_changed(direction):
	head_check.cast_to = Vector3(direction.x*1.5, 0, direction.z*1.5)
	body_check.cast_to = Vector3(direction.x*1.5, 0, direction.z*1.5)
	feet_check.cast_to = Vector3(direction.x*1.5, 0, direction.z*1.5)


func _on_Player_send_height(height):
	head_check.translation.y = height
	feet_check.translation.y = -height
	







