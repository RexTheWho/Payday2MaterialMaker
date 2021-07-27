extends Control

signal selected_new_material(mat_index, is_wear)

const amount = 6

func _ready():
	_connect_everything()
	for i in REF.mat_groups.size():
		var ref_data = REF.mat_groups[i]
		print(ref_data)
		
		var mat_button:TextureButton = get_node_or_null( "Buttons/Mat" + str(i+1) )
		if mat_button:
			mat_button.rect_min_size.x = REF.get_mint_width(i)
		
		var wear_button:TextureButton = get_node_or_null( "Buttons/Wear" + str(i+1) )
		if wear_button:
			wear_button.rect_min_size.x = REF.get_wear_width(i)


func _on_material_selected(index:int, is_wear:bool):
	# Replace this with a selector to refresh gradient sliders.
#	get_parent().get_parent().get_parent()._draw_changes()
	emit_signal("selected_new_material", index, is_wear)


func _on_material_mouse_entered(index:int, is_wear:bool):
	var label = $Label
	label.visible = true
	if !is_wear:
		label.text = REF.mat_groups[index].name
	else:
		label.text = REF.mat_groups[index].name + " Wear"


func _on_material_mouse_exited():
	var label = $Label
	label.visible = false


func _connect_everything():
	for i in range(amount):
		if get_node( "Buttons/Mat" + str(i+1) ).connect("mouse_entered", self, "_on_material_mouse_entered", [i, false]) != OK:
			push_warning("Failed to connect")
		
		if get_node( "Buttons/Wear" + str(i+1) ).connect("mouse_entered", self, "_on_material_mouse_entered", [i, true]) != OK:
			push_warning("Failed to connect")
			
		if get_node( "Buttons/Mat" + str(i+1) ).connect("pressed", self, "_on_material_selected", [i, false]) != OK:
			push_warning("Failed to connect")
		
		if get_node( "Buttons/Wear" + str(i+1) ).connect("pressed", self, "_on_material_selected", [i, true]) != OK:
			push_warning("Failed to connect")
		
		if get_node( "Buttons/Mat" + str(i+1) ).connect("mouse_exited", self, "_on_material_mouse_exited") != OK:
			push_warning("Failed to connect")
		
		if get_node( "Buttons/Wear" + str(i+1) ).connect("mouse_exited", self, "_on_material_mouse_exited") != OK:
			push_warning("Failed to connect")
