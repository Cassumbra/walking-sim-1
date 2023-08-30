extends CharacterBody3D

@export var object_name = "NULL"

@export var interact_type = "None" # (String, "None", "Talk", "Interact")

@export var interact_text = ["TEXT NO LOAD SORRY I ERROR TRY A FURTHER"] # (Array, String, MULTILINE)

@export var text_order = "Ordered" # (String, "Random", "Ordered")

#Any index within the interact_text array
var text_pointer = 0

@export var sprites # (Array, Texture2D)

@export var voices # (Array, AudioStream)

@export var snap_to_ground = true

var voice_index = 0

@onready var sprite = $Sprite3D
@onready var voice = $Voice

@onready var world

var player
var player_pos

signal interact(interactor)
signal send_object(bind)

#Define variables for corruption mechanics here:


#End of defining corruption mechanic variables.

@export var rotation_type = "Y-Billboard" # (String, "Y-Billboard", "Y-Billboard Flip", "Billboard", "Flat", "Spin")

@export var flip_h: bool

func _ready():
	sprites[0] = sprite.texture
	sprite.texture = sprites[randi() % sprites.size()]
	voice.stream = voices[randi() % voices.size()]
	
	if snap_to_ground:
		set_velocity(Vector3(0, 0, 0))
		# TODOConverter3To4 looks that snap in Godot 4 is float, not vector like in Godot 3 - previous value `Vector3.DOWN`
		set_up_direction(Vector3.UP)
		move_and_slide()
	
	
	#Make sure to also update world whenever world scene is changed!!
	#world = get_node("..")
	world = get_owner()
	connect("send_object", Callable(world, "_on_Object_send_object"))
	emit_signal("send_object", self)

	
func _process(delta):
	if rotation_type == "Y-Billboard":
		billboard()
		sprite.rotation_degrees.z = 0
		sprite.rotation_degrees.x = 0
	elif rotation_type == "Y-Billboard Flip":
		billboard(true)
		sprite.rotation_degrees.z = 0
		sprite.rotation_degrees.x = 0
	elif rotation_type == "Billboard":
		billboard()
	elif rotation_type == "Spin":
		sprite.rotation_degrees.x += 20 * delta
		
func billboard(flip = false):
	player_pos = player.get_node("Body").get_global_transform().origin
	sprite.look_at(player_pos, Vector3.UP)
	if flip:
		if sprite.rotation_degrees.y > -90 and sprite.rotation_degrees.y < 90:
			sprite.flip_h = not flip_h
		else:
			sprite.flip_h = flip_h

func play_sample():
	var player = voice.duplicate()
	add_child(player)
	player.play()
	await player.finished
	player.queue_free()
	
func interact(interactor):
	play_sample()
	emit_signal("interact", interactor)

func _on_World_send_player(p):
	player = p
	
