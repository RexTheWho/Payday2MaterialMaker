extends Control

export(NodePath) var textedit

func _ready():
	OS.min_window_size.x = OS.window_size.x
	OS.min_window_size.y = 250
	var file = File.new()
	var path = OS.get_executable_path().left(OS.get_executable_path().find_last("/"))
	var path_main = path + "/main.xml"
	if file.file_exists(path_main):
		prints("MAIN XML EXISTS!", path_main)
		_start_project(path)
	else:
		prints("NO MAIN XML, SET YOUR OWN OUTPUT!", path_main)


func _on_Button_pressed():
	var path = get_node(textedit).text
	_start_project(path)

func _start_project(path:String):
	var dir = Directory.new()
	if dir.dir_exists(path):
		REF.project_path = path
		if get_tree().change_scene_to(load("res://ROOT.tscn")) != OK:
			push_error("Cant change scene!")
