extends "res://objects/behaviors/behavior.gd"

var object
var from_scene
var add_player = false
var player

export(String, FILE) var to_scene_path
export var location = Vector3()

func _ready():
	yield(get_tree().root, "ready")
	object = get_parent()
	from_scene = object.get_parent()
	
func _process(delta):
	if add_player:
		print(str(get_world()))
		for child in get_world().get_children():
			print(str(child.name))
		add_player = false

func _on_interact(interactor):
	player = interactor.duplicate()
	player.set_name("Player")
	Global.goto_scene(to_scene_path, player)

func get_world():
	return get_tree().get_root().get_node("World")
