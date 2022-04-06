extends "res://objects/behaviors/behavior.gd"

var object
var from_scene
var player

export(String, FILE) var to_scene_path
export var to_location = Vector3()
export var rotation = Vector3()

signal change_scene(from_scene, to_scene_path, to_location)

func _ready():
	object = get_parent()
	from_scene = object.get_parent()
	connect("change_scene", get_main(), "change_world")



func _on_interact(interactor):
	emit_signal("change_scene", from_scene, to_scene_path, to_location, rotation)

func get_main():
	return get_tree().get_root().get_node("Main")
