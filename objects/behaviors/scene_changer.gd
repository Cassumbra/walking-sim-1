extends "res://objects/behaviors/behavior.gd"

var object
var from_scene
var player

export(String, FILE) var to_scene_path
export var to_location = Vector3()

func _ready():
	yield(get_tree().root, "ready")
	object = get_parent()
	from_scene = object.get_parent()

func _on_interact(interactor):
	pass

func get_world():
	return get_tree().get_root().get_node("World")
