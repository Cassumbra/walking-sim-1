extends KinematicBody

#Name of this object
export var object_name = "NULL"

#none, talk, interact
export var interact_type = "none"

#Array of strings
export(Array, String, MULTILINE) var interact_text = ["TEXT NO LOAD SORRY I ERROR TRY A FURTHER"]

#random, ordered
export var text_order = "ordered"

#Any index within the interact_text array
var text_pointer = 0

export(Array, Texture) var sprites

onready var sprite = $Sprite3D

var player
var player_pos

var billboard = false

func _ready():
	sprite.texture = sprites[randi() % sprites.size()]
	
	if is_instance_valid(sprite.texture):
		billboard = true
	player = get_tree().get_root().get_node("World").get_node("Player")
	
	move_and_collide(Vector3(0, 1, 0))
	
func _process(delta):
	if billboard:
		player_pos = player.body.get_global_transform().origin
		look_at(player_pos, Vector3.UP)
		rotation_degrees.z = 0
		rotation_degrees.x = 0
