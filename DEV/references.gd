extends Node

var project_name:String = "unnamed_skin"
var project_path:String

const default_icon_output = "assets/guis/dlcs/wep_skn_gen/textures/pd2/blackmarket/icons/weapon_color"
const default_generator_path = "assets/generated"
const mat_data_trim = 4
const mat_groups = [
	{
		name = "Metal Primary",
		mint_s = 0,
		wear_s = 13,
		wear_e = 43,
	},
	{
		name = "Plastic",
		mint_s = 43,
		wear_s = 53,
		wear_e = 86,
	},
	{
		name = "Rubber",
		mint_s = 86,
		wear_s = 98,
		wear_e = 128,
	},
	{
		name = "Metal Secondary",
		mint_s = 128,
		wear_s = 138,
		wear_e = 172,
	},
	{
		name = "Cloth",
		mint_s = 172,
		wear_s = 190,
		wear_e = 237,
	},
	{
		name = "Details",
		mint_s = 237,
		wear_s = 243,
		wear_e = 256,
	}
]
const mat_classes = {
	base_default = {
		name = "Default",
		rows = [1, 1, 1, 1, 1, 0]
	},
	base_metal = {
		name = "Metal",
		rows = [1, 0, 0, 1, 0, 0]
	},
	base_plastic = {
		name = "Plastic",
		rows = [0, 1, 1, 0, 0, 0]
	},
	base_half = {
		name = "Half 1",
		rows = [1, 0, 1, 0, 0, 0]
	},
	base_half_02 = {
		name = "Half 0",
		rows = [0, 1, 0, 1, 0, 0]
	},
	base_detail = {
		name = "Detail",
		rows = [0, 0, 0, 0, 0, 1]
	},
	base_variation = {
		name = "Variation",
		rows = [0, 0, 0, 0, 0, 0]
	}
}

func get_mint_width(index:int):
	var group_data = mat_groups[index]
	var width = group_data["wear_s"] - group_data["mint_s"]
	return width

func get_wear_width(index:int):
	var group_data = mat_groups[index]
	var width = group_data["wear_e"] - group_data["wear_s"]
	return width

func get_full_width(index:int):
	var group_data = mat_groups[index]
	var width = group_data["wear_e"] - group_data["mint_s"]
	return width

func get_mint_start(index:int):
	var group_data = mat_groups[index]
	return group_data["mint_s"]

func get_wear_start(index:int):
	var group_data = mat_groups[index]
	return group_data["wear_s"]

func get_wear_end(index:int):
	var group_data = mat_groups[index]
	return group_data["wear_e"]

func get_project_path():
	var path:String
	if project_path:
		path = project_path
	else:
		project_path = "C:/Program Files (x86)/Steam/steamapps/common/PAYDAY 2/assets/mod_overrides/WeaponSkinGenerator/"
	return path + "/"
