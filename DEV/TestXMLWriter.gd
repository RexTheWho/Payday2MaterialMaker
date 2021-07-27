extends Control

var mainxml = "C:/Program Files (x86)/Steam/steamapps/common/PAYDAY 2/assets/mod_overrides/WeaponSkinGenerator/main.xml"

func _on_Button_pressed():
	
	var file = File.new()
	file.open(mainxml, File.READ)
	var file_text = file.get_as_text()
	$PanelContainer/VBoxContainer/TextEdit.text = file_text
	
	var limit = 8
	var found_skins = []
	print( file_text.count("WeaponSkin", 34, file_text.length()) )
	
	# XML
	var SAV_XML = load("res://Tools/export_skin_xml.gd").new()
	SAV_XML.export_merged_xml( REF.get_project_path() + "main.xml" )
