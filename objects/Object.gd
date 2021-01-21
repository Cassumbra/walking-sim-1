extends KinematicBody

export var object_name = "NULL"

export(String, "None", "Talk", "Interact") var interact_type = "None"

export(Array, String, MULTILINE) var interact_text = ["TEXT NO LOAD SORRY I ERROR TRY A FURTHER"]

export(String, "Random", "Ordered") var text_order = "Ordered"

#Any index within the interact_text array
var text_pointer = 0

export(Array, Texture) var sprites

export(Array, AudioStream) var voices

var voice_index = 0

onready var sprite = $Sprite3D
onready var voice = $Voice

var player
var player_pos

signal interact(interactor)

#Define variables for corruption mechanics here:


#End of defining corruption mechanic variables.

export(String, "Y-Billboard", "Billboard", "Flat", "Spin") var rotation_type = "Y-Billboard"

func _ready():
	sprite.texture = sprites[randi() % sprites.size()]
	voice.stream = voices[randi() % voices.size()]
	
	move_and_collide(Vector3(0, 1, 0))
	
func _process(delta):
	if rotation_type == "Y-Billboard":
		billboard()
		rotation_degrees.z = 0
		rotation_degrees.x = 0
	elif rotation_type == "Billboard":
		billboard()
	elif rotation_type == "Spin":
		rotation_degrees.y += 20 * delta
		
func billboard():
	yield(get_tree().root, "ready")
	player_pos = player.body.get_global_transform().origin
	look_at(player_pos, Vector3.UP)

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

func _on_Object_tree_entered():
	yield(get_tree().root, "ready")
	player = get_tree().get_root().get_node("World").get_node("Player")
