extends "res://objects/object.gd"

func _ready():
	pass # Replace with function body.

func _process(delta):
	player_pos = player.get_node("Body").get_global_transform().origin
	look_at(player_pos, Vector3.UP)
	translate(Vector3 (0, 0, -delta*25))
