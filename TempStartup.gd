extends Control

func _on_Button_pressed():
	var path = $PanelContainer/HBoxContainer/TextEdit.text
	var dir = Directory.new()
	if dir.dir_exists(path):
		REF.project_path = path
		if get_tree().change_scene_to(load("res://ROOT.tscn")) != OK:
			push_error("Cant change scene!")
