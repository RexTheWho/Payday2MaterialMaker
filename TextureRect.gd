extends TextureRect

var working_image:Image

func _ready():
	working_image = Image.new()
	working_image.create(256, 256, false, Image.FORMAT_RGBA8)
	working_image.lock()
	working_image.fill(Color.red)
	_draw_changes()

func _draw_changes():
	for i in REF.mat_groups.size():
		var mint_width = REF.get_mint_width(i)
		var wear_width = REF.get_wear_width(i)
		var vertical_gradient_range = 256 - REF.mat_data_trim
		var trim_color = Color(rand_range(0.2,0),rand_range(0.5,0),rand_range(1,0))
		var trimwear_color = Color(rand_range(0.2,0),rand_range(0.5,0),rand_range(1,0))
		var wear_color = Color(rand_range(0.2,0),rand_range(0.5,0),rand_range(1,0))
		var mint_color = Color(rand_range(1,.5),rand_range(0.5,0.3),rand_range(1,0.3))
		
		# MINT
		for y in range(vertical_gradient_range):
			for x in range(mint_width):
				working_image.lock()
				working_image.set_pixel(REF.get_mint_start(i) + x, y + REF.mat_data_trim, mint_color * sin((256-y)/256.0))
		
		# MARK WEAR
		for y in range(vertical_gradient_range):
			for x in range(wear_width):
				working_image.lock()
				working_image.set_pixel(REF.get_wear_start(i) + x, y + REF.mat_data_trim, wear_color)
		
		# TRIM Mint
		for y in range(REF.mat_data_trim):
			for x in range(mint_width):
				working_image.lock()
				working_image.set_pixel(REF.get_mint_start(i) + x, y, trim_color)
		
		# TRIM Wear
		for y in range(REF.mat_data_trim):
			for x in range(wear_width):
				working_image.lock()
				working_image.set_pixel(REF.get_wear_start(i) + x, y, trimwear_color)
	
	working_image.unlock()
	
	var new_tex = ImageTexture.new()
	new_tex.create_from_image(working_image, 32)
	texture = new_tex
	if working_image.save_png( OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "\\temp.png" ) != OK:
		push_error("Failed to save base_gradient!!")
