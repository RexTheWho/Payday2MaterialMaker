extends Control

signal selected_new_material(mat_index, is_wear)

func _ready():
	_set_paint_gaps(true)
	_connect_everything()


# This is very busted due to 256 not being divisible by 6- Look into a better option. Or just remove it.
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


# I think this is fine- need to go over it.
func _on_material_selected(index:int, is_wear:bool):
	# Replace this with a selector to refresh gradient sliders.
#	get_parent().get_parent().get_parent()._draw_changes()
	emit_signal("selected_new_material", index, is_wear)


# I dont know if this is used anymore.
func _on_PanelLayoutEditor_toggle_paintstrip_gap_modes(mode:bool):
	_set_paint_gaps(mode)


# Initial connections, not accurate
func _connect_everything():
	for i in range(6):
		if get_node( "Buttons/Mat" + str(i+1) ).connect("pressed", self, "_on_material_selected", [0, false]) != OK:
			push_warning("Failed to connect")
		if get_node( "Buttons/Wear" + str(i+1) ).connect("pressed", self, "_on_material_selected", [0, true]) != OK:
			push_warning("Failed to connect")


# Take the strip_index and set the material to open its gradient_index item.
func set_strip_index_to_new_gradient(strip_index:int, gradient_index:int):
	var mint = get_node( "Buttons/Mat" + str(strip_index+1) )
	var wear = get_node( "Buttons/Wear" + str(strip_index+1) )
	
	mint.disconnect("pressed", self, "_on_material_selected")
	wear.disconnect("pressed", self, "_on_material_selected")
	
	if mint.connect("pressed", self, "_on_material_selected", [gradient_index, false]) != OK:
		push_warning("Failed to connect")
	if wear.connect("pressed", self, "_on_material_selected", [gradient_index, true]) != OK:
		push_warning("Failed to connect")


