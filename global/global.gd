extends Node

var corruption = 0

func _ready():	
	get_window().mode = Window.MODE_MAXIMIZED if (true) else Window.MODE_WINDOWED
	randomize()

