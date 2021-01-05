extends Spatial

var i_distance = 2

onready var i_check = $InteractableCheck
onready var collider = $Collider
onready var head = $Collider/Head

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	i_check.rotation_degrees.x = head.rotation.x
	i_check.rotation_degrees.y = collider.rotation_degrees.x
	i_check.cast_to = Vector3(i_distance, 0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
