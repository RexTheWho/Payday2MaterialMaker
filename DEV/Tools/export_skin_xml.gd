extends Node

var template = "<WeaponSkin id=\"{id_name}\" is_a_color_skin=\"true\" global_value=\"wep_skn_gen\">"

func export_merged_xml(path:String):
	print(path)
	print( template.format({"id_name": REF.project_name}) )
