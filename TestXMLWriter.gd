extends Control

var mainxml = "C:/Program Files (x86)/Steam/steamapps/common/PAYDAY 2/assets/mod_overrides/WeaponSkinGenerator/main.xml"

func _on_Button_pressed():
	
	var file = File.new()
	file.open(mainxml, File.READ)
	$PanelContainer/VBoxContainer/TextEdit.text = file.get_as_text()
