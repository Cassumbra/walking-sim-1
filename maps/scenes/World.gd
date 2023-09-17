extends Node3D

signal send_player(player)

var player


func _on_Main_send_player(p):
	player = p
	emit_signal("send_player", player)
	
func _on_Object_send_object(bind):
	print("object received!")
	connect("send_player", Callable(bind, "_on_World_send_player"))

