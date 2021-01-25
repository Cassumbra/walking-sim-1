extends Spatial

signal send_player(player)
signal change_scene()

onready var player = $Player
onready var HUD = $Player/HUD
onready var world = $World
onready var new_world



func _ready():
	emit_signal("send_player", player)
	connect("change_scene", HUD, "_on_Main_change_scene")
	
	
func change_world(from_scene, to_scene_path, to_location, rotation):
	
	emit_signal("change_scene")
	
	world.queue_free()
	new_world = add_child(load(to_scene_path).instance())
	for child in get_children():
		if child.name.countn("World") > 0:
			world = child
	

	player.body.global_transform.origin = to_location
	player.body.rotation = Vector3(0, 0, 0)
	player.body.rotate_x(rotation.x)
	player.body.rotate_y(rotation.y)
	player.body.rotate_z(rotation.z)

	connect("send_player", world, "_on_Main_send_player")
	emit_signal("send_player", player)

func _on_SceneChanger_change_scene():
	pass
