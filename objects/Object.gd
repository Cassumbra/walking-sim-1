extends KinematicBody

export var object_name = "NULL"

export(String, "None", "Talk", "Interact") var interact_type = "None"

export(Array, String, MULTILINE) var interact_text = ["TEXT NO LOAD SORRY I ERROR TRY A FURTHER"]

export(String, "Random", "Ordered") var text_order = "Ordered"

#Any index within the interact_text array
var text_pointer = 0

export(Array, Texture) var sprites

export(Array, AudioStream) var voices

export var static = false

var voice_index = 0

onready var sprite = $Sprite3D
onready var voice = $Voice

onready var world

var player
var player_pos

signal interact(interactor)
signal send_object(bind)

#Define variables for corruption mechanics here:


#End of defining corruption mechanic variables.

export(String, "Y-Billboard", "Y-Billboard Flip", "Billboard", "Flat", "Spin") var rotation_type = "Y-Billboard"

export(bool) var flip_h

func _ready():
	sprite.texture = sprites[randi() % sprites.size()]
	voice.stream = voices[randi() % voices.size()]
	
	if not static:
		move_and_collide(Vector3(0, 1, 0))
	
	#Make sure to also update world whenever world scene is changed!!
	world = get_node("..")
	connect("send_object", world, "_on_Object_send_object")
	emit_signal("send_object", self)

	
func _process(delta):
	if rotation_type == "Y-Billboard":
		billboard()
		rotation_degrees.z = 0
		rotation_degrees.x = 0
	elif rotation_type == "Y-Billboard Flip":
		billboard(true)
		rotation_degrees.z = 0
		rotation_degrees.x = 0
	elif rotation_type == "Billboard":
		billboard()
	elif rotation_type == "Spin":
		rotation_degrees.y += 20 * delta
		
func billboard(flip = false):
	player_pos = player.get_node("Body").get_global_transform().origin
	look_at(player_pos, Vector3.UP)
	if flip:
		print(str(rotation_degrees.y))
		if rotation_degrees.y > -90 and rotation_degrees.y < 90:
			sprite.flip_h = not flip_h
		else:
			sprite.flip_h = flip_h

func play_sample():
	var player = voice.duplicate()
	add_child(player)
	player.play()
	yield(player, "finished")
	player.queue_free()
	
func interact(interactor):
	play_sample()
	#print(str(interactor))
	emit_signal("interact", interactor)

func _on_World_send_player(p):
	player = p
	
