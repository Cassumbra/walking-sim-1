extends Node

var corruption = 0
var player
var player_saved = false

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	OS.set_window_maximized(true)
	randomize()
	
func spawn_player():
	get_world().add_child(player)
	for child in get_world().get_children():
		print(str(child.name))

func get_world():
	return get_tree().get_root().get_node("World")

func load_player(p):
	if player_saved:
		p = player
		print(str(p.get_node("Body").get_node("BodyShape").scale.y))
		print(str(player.get_node("Body").get_node("BodyShape").scale.y))
	else:
		#print("Too early to save...")
		player_saved = true

func goto_scene(path, entity):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path, entity)


func _deferred_goto_scene(path, entity):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)

	player = entity

