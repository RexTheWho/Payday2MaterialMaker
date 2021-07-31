extends PanelContainer

signal change_material_variation(material_var)
signal change_paintstrip_index(modified_material_variations)
signal toggle_paintstrip_gap_modes(mode)
var current_mat_class = "base_default"
var modified_material_variations = REF.material_variations

func _ready():
	_setup_material_tweaker_names()
	_update_material_tweaker_values(current_mat_class)
	_update_spinbox_min_max(6)
	_update_spinbox_values()
	_connect_spinbox_value_changes()
	$MainV/VariationBox/PanelContainer/Label.text = current_mat_class


func _update_material_tweaker_values(group:String):
	var path = $MainV/Tweaker
	var data = modified_material_variations[group]["rows"]
	for i in data.size():
		var node_name:SpinBox = path.get_node("SpinBox" + str(i))
		node_name.value = data[i]


func _setup_material_tweaker_names():
	var path = $MainV/Tweaker
	for i in REF.paint_strips.size():
		var data = REF.paint_strips[i]
		var node_name:Label = path.get_node("Name" + str(i))
		node_name.text = data.name


func _on_Previous_pressed():
	current_mat_class = get_previous_class()
	$MainV/VariationBox/PanelContainer/Label.text = current_mat_class
#	emit_signal("change_material_variation", current_mat_class)
	emit_signal("change_material_variation", modified_material_variations[current_mat_class])


func _on_Next_pressed():
	current_mat_class = get_next_class()
	$MainV/VariationBox/PanelContainer/Label.text = current_mat_class
#	emit_signal("change_material_variation", current_mat_class)
	emit_signal("change_material_variation", modified_material_variations[current_mat_class])


func _on_PanelLayoutEditor_change_material_variation(_material_var):
	_update_spinbox_values()


func get_next_class():
	var classes = modified_material_variations.keys()
	var curr_idx = classes.find(current_mat_class)
	if curr_idx+1 >= classes.size():
		return classes[0]
	else:
		return classes[curr_idx+1]


func get_previous_class():
	var classes = modified_material_variations.keys()
	var curr_idx = classes.find(current_mat_class)
	return classes[curr_idx-1]


func _update_spinbox_values():
	for i in 6:
		var node:SpinBox = get_node_or_null("MainV/Tweaker/SpinBox" + str(i))
		if node:
			var new_value = modified_material_variations[current_mat_class].rows[i]
			node.value = new_value


func _update_spinbox_min_max(new_max:int):
	for i in range(6):
		var node:SpinBox = get_node_or_null("MainV/Tweaker/SpinBox" + str(i))
		if node:
			node.max_value = new_max


func _connect_spinbox_value_changes():
	for i in range(6):
		var node:SpinBox = get_node_or_null("MainV/Tweaker/SpinBox" + str(i))
		if node and node.connect("value_changed", self, "_updated_paintstrip_index", [i]) != OK:
			push_warning("Paint Strip Spinboxes not linked!")


func _updated_paintstrip_index(value:int, pos_in_index:int):
	prints("updated paintstrip index", pos_in_index, "to", value)
	modified_material_variations[current_mat_class].rows[pos_in_index] = value
	emit_signal("change_paintstrip_index", modified_material_variations)


func _on_CheckBox_toggled(button_pressed):
	emit_signal("toggle_paintstrip_gap_modes", button_pressed)
