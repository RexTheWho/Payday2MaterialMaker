extends PanelContainer

const HEADER = {
	file = 0x20534444, # Spells out "DDS"
	size = 0x0000007C, # ???
	comp = 0x0000100F, # Compression formats
	high = 0x00000004, # Get Height HEX
	
	wdth = 0x00000004, # Get Width HEX
	ukn5 = 0x00000010, # ???
	ukn6 = 0x00000000, # ???
	ukn7 = 0x00000001, # ???
	
	dsc1 = 0x2D584552, # Desc1
	dsc2 = 0x5344442D, # Desc2
	uk10 = 0x00030001, # ???
	uk11 = 0x00000000, # ???
	
	uk12 = 0x00000000, # ???
	uk13 = 0x00000000, # ???
	uk14 = 0x00000000, # ???
	uk15 = 0x00000000, # ???
	
	uk16 = 0x00000000, # ???
	uk17 = 0x00000000, # ???
	uk18 = 0x00000000, # ???
	uk19 = 0x00000020, # ???
	
	uk20 = 0x00000041, # ???
	uk21 = 0x00000000, # ???
	uk22 = 0x00000020, # ???
	uk23 = 0x00FF0000, # ???
	
	uk24 = 0x0000FF00, # ???
	uk25 = 0x000000FF, # ???
	uk26 = 0xFF000000, # ???
	uk27 = 0x00001000, # ???
	
	uk28 = 0x00000000, # ???
	uk29 = 0x00000000, # ???
	uk30 = 0x00000000, # ???
	uk31 = 0x00000000, # ???
}


func _on_Button_pressed():
#	_copy_save_dds()
	var base_texture:Image = Image.new()
	base_texture.load("res://Textures/color_white2.png")
	
	_make_dds_from_image(base_texture)

func _make_dds():
	var resolution = Vector2(256,128)
	var file = File.new()
	var dir = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "\\TEST_DDS.dds"
	file.open( dir, File.WRITE )
	if file.is_open():
		print("MAKING DDS")
		for i in HEADER:
			#If its a resolution setting save that, otherwise take presets from cons HEADER
			if i == "high":
				file.store_32(resolution.y)
			elif i == "wdth":
				file.store_32(resolution.x)
			else:
				file.store_32(HEADER[i])
		
		# Generate filler noise for now
		var filler:PoolByteArray
		for i in 32 - HEADER.size():
			filler.append_array([0,0,0,0])
		for i in resolution.x * resolution.y:
			filler.append_array([randi()%256,randi()%256,randi()%256,randi()%256])
		
		# Save and close file
		file.store_buffer(filler)
		file.close()
		print("COMPLETE")
	else:
		push_error("NOT OPEN")

func _make_dds_from_image(image:Image):
	var data:PoolByteArray = image.data.data
	var resolution = Vector2( image.data.width, image.data.height)
	
	var file = File.new()
	var dir = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "\\TEST_DDS.dds"
	file.open( dir, File.WRITE )
	if file.is_open():
		print("MAKING DDS")
		for i in HEADER:
			#If its a resolution setting save that, otherwise take presets from cons HEADER
			if i == "high":
				file.store_32(resolution.y)
			elif i == "wdth":
				file.store_32(resolution.x)
			else:
				file.store_32(HEADER[i])
		
		# Fill in any missing header info
		var filler:PoolByteArray
		for i in 32 - HEADER.size():
			filler.append_array([0,0,0,0])
			
		# Generate filler noise for now
		var step = 0
		for i in resolution.x * resolution.y:
			filler.append_array([data[step], data[step+1], data[step+2], data[step+3]])
			step += 4
		
		# Save and close file
		file.store_buffer(filler)
		file.close()
		print("COMPLETE")
	else:
		push_error("NOT OPEN")

func _copy_save_dds():
	
	var file = File.new()
	file.open("res://Textures/test.dds", File.READ)
	
	var _file_len = file.get_len()
	
	_inspect_dds_header(file)
	
	file.close()

const head_check = [
	# 00 00 00 00
	"MagicNum",			"dwSize",			"Compression",		"Height",
	# 00 00 00 16
	"Width",			"Something 16",		"Something 1",		"GIMP",
	# 00 00 00 32
	"-DDS",
#	"-DDS",				"Something 1",		"Something 0",		"Something 0",
	# 00 00 00 48
#	"Something 0",		"Something 0",		"Something 0",		"Something 0",
	# 00 00 00 64
#	"Something 0",		"Something 0",		"Something 0",		"Something 32",
	# 00 00 00 80
#	"Something 65",		"Something 0",		"Something 32",		"Something 0",
	# 00 00 00 96
#	"Something 65",		"Something 0",		"Something 32",		"Something 0",
	]
func _inspect_dds_header(file:File):
	for i in head_check:
		var buffer = file.get_buffer(4)
		print("\n" + i + " > " + buffer.hex_encode())
		get_print_buffer(buffer)

func _generate_dds_header(width:int, height:int):
	prints(width, height)
	var buffer:PoolByteArray = []
	
	buffer.append_array([68, 68, 83, 32])


func get_print_buffer(buffer:PoolByteArray):
	var arr = ""
	var arr_n = 0
	for i in buffer:
		arr += str(i).pad_zeros(3) + " "
		arr_n += 1
		if arr_n == 8:
			arr += "\n"
			arr_n=0
	print( arr )
