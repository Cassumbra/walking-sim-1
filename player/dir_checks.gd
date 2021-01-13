extends Spatial

var cast_dist = 1


onready var head_check = $HeadCheck
onready var body_check = $BodyCheck
onready var feet_check = $FeetCheck

#i need to tell player what my raycasts are hitting

func _ready():
	pass 
	#i need player to tell me where my check heights should be
	

func _on_Player_direction_changed(direction):
	print("fucker")
	head_check.cast_to = Vector3(10, 0, 0)
	body_check.cast_to = Vector3(10, 0, 0)
	feet_check.cast_to = Vector3(10, 0, 0)

func _on_Player_send_height(height):
	head_check.translation.y = height/2
	feet_check.translation.y = -height/2
