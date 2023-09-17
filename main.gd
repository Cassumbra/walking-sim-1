extends Node3D

signal send_player(player)
signal change_scene_to_file(to_location)

@onready var player = $Player
@onready var HUD = $Player/HUD
@onready var world = $World
@onready var new_world


func _ready():
	connect("send_player", Callable(world, "_on_Main_send_player"))
	emit_signal("send_player", player)
	
	connect("change_scene_to_file", Callable(HUD, "_on_Main_change_scene"))
	
	
func change_world(from_scene, to_scene_path, to_location, rotation):
	
	emit_signal("change_scene_to_file", to_location)
	
	world.queue_free()
	add_child(load(to_scene_path).instantiate())
	for child in get_children():
		if child.name.countn("World") > 0:
			world = child
	

	player.body.global_transform.origin = to_location
	player.body.rotation = Vector3.ZERO
	player.body.h_velocity = Vector3.ZERO
	
	player.body.rotate_x(rotation.x)
	player.body.rotate_y(rotation.y)
	player.body.rotate_z(rotation.z)
	
	player.hud.scene_transition()
	
	connect("send_player", Callable(world, "_on_Main_send_player"))
	emit_signal("send_player", player)

func _on_SceneChanger_change_scene():
	pass

func _on_Player_ready():
	# I don't know why this was connected, but maybe there was a reason?
	pass
