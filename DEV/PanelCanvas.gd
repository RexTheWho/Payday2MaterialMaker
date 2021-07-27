extends PanelContainer

export(NodePath) var project_manager
export(NodePath) var sprite
var working_image:Image

func _ready():
	# Could do with a better handling here
	if project_manager and get_node(project_manager).connect("export_project", self, "_export_project", []) != OK:
		push_warning("ERR")
	
	randomize()
	for _i in range(2):
		_draw_changes()


func _export_project(project_name):
	print("EXPORT")
	var output_loc = REF.get_project_path() + REF.default_generator_path + "/base_gradient/"
	for material_type in REF.mat_classes:
		var output_name = project_name + "_" + material_type
		var SAV_DDS = load("res://Tools/export_dds.gd").new()
		_draw_changes()
		if SAV_DDS.save_dds_from_image(working_image, output_loc + output_name) != OK:
			push_error("Failed to save base_gradient at " + output_loc + output_name)
	# XML
	var SAV_XML = load("res://Tools/export_skin_xml.gd").new()
	SAV_XML.export_merged_xml( REF.get_project_path() + "main.xml" )

func _draw_changes():
	working_image = Image.new()
	working_image.create(256, 256, false, Image.FORMAT_RGBA8)
	working_image.lock()
	working_image.fill(Color.red)
	for i in REF.mat_groups.size():
		var mint_width = REF.get_mint_width(i)
		var wear_width = REF.get_wear_width(i)
		var vertical_gradient_range = 256 - REF.mat_data_trim
		var trim_color = random_trim_color(false)
		var trimwear_color = random_trim_color(true)
		var wear_color = random_controlled_color(0.3, 0.5, 0.9, 1.0)
		var mint_color = random_color()
		
		# COLOR MINT
		for y in range(vertical_gradient_range):
			for x in range(mint_width):
				var color = mint_color
#				color *= sin((256-y)/256.0)
				# Mix with gradient
#				color *= $TEMP.texture.gradient.interpolate(1-get_ratiof(y, vertical_gradient_range))
				working_image.lock()
				working_image.set_pixel(REF.get_mint_start(i) + x, y + REF.mat_data_trim, color)
		
		# COLOR WEAR
		for y in range(vertical_gradient_range):
			for x in range(wear_width):
				var wear_color_blend:Color = wear_color
				wear_color_blend.v *= 1.0 - get_ratiof(x, wear_width)
				working_image.lock()
				working_image.set_pixel(REF.get_wear_start(i) + x, y + REF.mat_data_trim, wear_color_blend)
		
		# TRIM MINT
		for y in range(REF.mat_data_trim):
			for x in range(mint_width):
				working_image.lock()
				working_image.set_pixel(REF.get_mint_start(i) + x, y, trim_color)
		
		# TRIM WEAR
		for y in range(REF.mat_data_trim):
			for x in range(wear_width):
				working_image.lock()
				working_image.set_pixel(REF.get_wear_start(i) + x, y, trimwear_color)
	
	working_image.unlock()
	
	var new_tex = ImageTexture.new()
	new_tex.create_from_image(working_image, 32)
	if sprite:
		print("update texture")
		get_node(sprite).texture = new_tex


func _on_BackgroundToggle_toggled(button_pressed):
	$VBoxContainer/Result/BGVisuals.visible = button_pressed


func random_color():
	var grey = rand_range(1,0)
	return Color(grey,grey,grey,randi()%2)
#	return Color(rand_range(1,0),rand_range(1,0),rand_range(1,0),randi()%2)


func random_controlled_color(rgb_start:float, rgb_end:float, alpha_start:float, alpha_end:float):
	return Color(
		rand_range(rgb_start, rgb_end),
		rand_range(rgb_start, rgb_end),
		rand_range(rgb_start, rgb_end),
		rand_range(alpha_start, alpha_end)
	)


func random_trim_color(is_wear:bool):
	var value = Color(
		rand_range(0.1,0.2),
		rand_range(0.7,1.0),
		rand_range(0.0,0.1),
		rand_range(0.5,0.8)
	)
	if is_wear:
		value.v *= 0.3
	return value

func get_ratiof(a:float, b:float):
	return a / (b - 1)



func _on_MaterialSelect_selected_new_material(mat_index, is_wear):
	prints("Selected new material", mat_index, is_wear)
	var node = $List/PanelMaterialEditor
	node.change_current_material(mat_index, is_wear)
	

