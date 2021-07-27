extends Node

const HEADER_SIZE = 128
const HEADER = {
	file = 0x20534444, # Spells out "DDS"
	size = 0x0000007C, # ???
	comp = 0x0000100F, # Compression formats
	high = 0x00000004, # Get Height HEX
	
	wdth = 0x00000004, # Get Width HEX
	ukn5 = 0x00000010, # ???
	ukn6 = 0x00000000, # ???
	ukn7 = 0x00000001, # ???
	
	dsc1 = 0x2D584552, # Desc1?
	dsc2 = 0x5344442D, # Desc2?
	uk10 = 0x00030001, # ???
	uk11 = 0x00000000, # ???

	uk12 = 0x00000000, # ???
	uk13 = 0x00000000, # ??? I
	uk14 = 0x00000000, # ??? dont
	uk15 = 0x00000000, # ??? actually

	uk16 = 0x00000000, # ??? know
	uk17 = 0x00000000, # ??? what
	uk18 = 0x00000000, # ??? this
	uk19 = 0x00000020, # ??? stuff

	uk20 = 0x00000041, # ??? does
	uk21 = 0x00000000, # ??? I
	uk22 = 0x00000020, # ??? stole
	uk23 = 0x00FF0000, # ??? it

	uk24 = 0x0000FF00, # ??? from
	uk25 = 0x000000FF, # ??? a
	uk26 = 0xFF000000, # ??? dds
	uk27 = 0x00001000, # ??? file

	uk28 = 0x00000000, # ??? cos
	uk29 = 0x00000000, # ??? Im
	uk30 = 0x00000000, # ??? dumb
	uk31 = 0x00000000, # ???
}


func save_dds_from_image(image:Image, save_to:String):
	var data:PoolByteArray = image.data.data
	var resolution = Vector2( image.data.width, image.data.height)
	
	var file = File.new()
	var dir = save_to + ".dds"
	
	file.open( dir, File.WRITE )
	if file.is_open():
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
		for i in (HEADER_SIZE / 4) - HEADER.size():
			filler.append_array([0,0,0,0])
			
		# Save each pixel from image
		var step = 0
		for i in resolution.x * resolution.y:
			# B G R A
			filler.append_array([data[step+2], data[step+1], data[step], data[step+3]])
			step += 4
		
		# Save and close file
		file.store_buffer(filler)
		file.close()
		return OK
	else:
		return FAILED
