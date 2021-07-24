extends Control

func _ready():
	OS.min_window_size.x = OS.window_size.x
	OS.min_window_size.y = 250
