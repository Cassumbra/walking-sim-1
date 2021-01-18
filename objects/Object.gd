extends KinematicBody

#Name of this object
export var object_name = "NULL"

#none, talk, interact
export(String, "None", "Talk", "Interact") var interact_type

#Array of strings
export(Array, String, MULTILINE) var interact_text = ["TEXT NO LOAD SORRY I ERROR TRY A FURTHER"]

#random, ordered
export(String, "Random", "Ordered") var text_order

#Any index within the interact_text array
var text_pointer = 0

export(Array, Texture) var sprites

export(Array, AudioStream) var voices

var voice_index = 0

onready var sprite = $Sprite3D
onready var voice = $Voice

var player
var player_pos

export(String, "Y-Billboard", "Billboard", "Flat", "Spin") var rotation_type

func _ready():
	sprite.texture = sprites[randi() % sprites.size()]
	voice.stream = voices[randi() % voices.size()]
	
	player = get_tree().get_root().get_node("World").get_node("Player")
	
	move_and_collide(Vector3(0, 1, 0))
	
func _process(delta):
	if rotation_type == "billboard":
		player_pos = player.body.get_global_transform().origin
		look_at(player_pos, Vector3.UP)
		rotation_degrees.z = 0
		rotation_degrees.x = 0
		
func play_sample():
	var player = voice.duplicate()
	add_child(player)
	player.play()
	yield(player, "finished")
	player.queue_free()
	#ASP3Ds now get freed upon completion- pog!!
