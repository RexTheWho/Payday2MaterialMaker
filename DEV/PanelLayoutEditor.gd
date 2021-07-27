extends PanelContainer

signal change_material_group(index)
var current_mat_class = "base_default"

func _ready():
	_setup_material_tweaker_names()
	_update_material_tweaker_values(current_mat_class)




func _update_material_tweaker_values(group:String):
	var path = $MainV/Tweaker
	var data = REF.mat_classes[group]["rows"]
	for i in data.size():
		var node_name:SpinBox = path.get_node("SpinBox" + str(i))
		node_name.value = data[i]


func _setup_material_tweaker_names():
	var path = $MainV/Tweaker
	for i in REF.mat_groups.size():
		var data = REF.mat_groups[i]
		var node_name:Label = path.get_node("Name" + str(i))
		node_name.text = data.name


func _on_Previous_pressed():
	current_mat_class = get_previous_class()
	$MainV/VariationBox/PanelContainer/Label.text = current_mat_class


func _on_Next_pressed():
	current_mat_class = get_next_class()
	$MainV/VariationBox/PanelContainer/Label.text = current_mat_class


func get_next_class():
	var classes = REF.mat_classes.keys()
	var curr_idx = classes.find(current_mat_class)
	if curr_idx+1 >= classes.size():
		return classes[0]
	else:
		return classes[curr_idx+1]

func get_previous_class():
	var classes = REF.mat_classes.keys()
	var curr_idx = classes.find(current_mat_class)
	return classes[curr_idx-1]





