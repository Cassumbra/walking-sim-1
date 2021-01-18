extends Spatial
var offset = 6

onready var eyes = $Eyes

onready var look_direction = $LookDirection
var look_distance = 12
var object
signal look_object(object)

func _process(_delta):
	look_direction.cast_to = Vector3(0, 0, -look_distance)
	
	if look_direction.is_colliding():
		object = look_direction.get_collider()
		emit_signal("look_object", object)
	else:
		object = "none"
		emit_signal("look_object", object)
		

func _on_Body_send_height(height):
	translation.y = height - height/offset
	
#Debug
#func _ready():
#	eyes.clear_current(true)
