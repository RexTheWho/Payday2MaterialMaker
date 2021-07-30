extends Control

signal selected_new_material(mat_index, is_wear)

func _ready():
	_set_paint_gaps(true)
	_connect_everything()

func _set_paint_gaps(proper:bool):
	for i in REF.paint_strips.size():
		var ref_data = REF.paint_strips[i]
		print(ref_data)
		
		var mat_button:TextureButton = get_node_or_null( "Buttons/Mat" + str(i+1) )
		if mat_button:
			if proper:
				mat_button.rect_min_size.x = REF.get_mint_width(i)
			else:
				mat_button.rect_min_size.x = 21
		
		var wear_button:TextureButton = get_node_or_null( "Buttons/Wear" + str(i+1) )
		if wear_button:
			if proper:
				wear_button.rect_min_size.x = REF.get_wear_width(i)
			else:
				wear_button.rect_min_size.x = 21


func _on_material_selected(index:int, is_wear:bool):
	# Replace this with a selector to refresh gradient sliders.
#	get_parent().get_parent().get_parent()._draw_changes()
	emit_signal("selected_new_material", index, is_wear)


func _on_PanelLayoutEditor_toggle_paintstrip_gap_modes(mode:bool):
	_set_paint_gaps(mode)


func _connect_everything():
	for i in range(6):
		if get_node( "Buttons/Mat" + str(i+1) ).connect("pressed", self, "_on_material_selected", [i, false]) != OK:
			push_warning("Failed to connect")
		if get_node( "Buttons/Wear" + str(i+1) ).connect("pressed", self, "_on_material_selected", [i, true]) != OK:
			push_warning("Failed to connect")
