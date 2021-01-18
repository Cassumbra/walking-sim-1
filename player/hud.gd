extends Control

#i need to put the crosshair at the center of the screen, wherever that is.
#i need to change my crosshair when player tells me to

onready var crosshair = $CenterContainer/Crosshair
onready var message = $MessagePanel/Message
onready var fps = $FpsPanel/Fps

var texture_none = load("res://ui/none.png")
var texture_interact = load("res://ui/interact.png")
var talk = load("res://ui/talk.png")

#func _ready():
#	randomize()

func _process(delta):
	fps.set_text(str(Engine.get_frames_per_second()))

func _on_Player_look_object(object, interact):
	if typeof(object) == 4:
		crosshair.texture = texture_none
	elif object.interact_type == "interact":
		crosshair.texture = texture_interact
	elif object.interact_type == "talk":
		crosshair.texture = talk
	if interact:
		if object.text_order == "random":
			message.text = object.interact_text[randi() % object.interact_text.size()]
		elif object.text_order == "ordered":
			message.text = object.interact_text[object.text_pointer]
			object.text_pointer += 1
			if object.text_pointer > object.interact_text.size() - 1:
				object.text_pointer = 0


