extends Control

const pattern_key_search = ['pattern ', 'pattern_default ']
const ignored_dlc = ["nin", "cs3", "smosh", "skf", "same", "css", "cs4", "cat", "ait"]

onready var progress_bar = $PanelContainer/VBoxContainer/ProgressBar
var time = 0

func _ready():
	if get_tree().connect("files_dropped", self, "_files_dropped") != OK: push_error("ERR")

func _files_dropped(files:PoolStringArray, _screen:int):
	time = OS.get_ticks_msec()
	progress_bar.get_node("Label").text = "Indexing..."
	var tweakdata_path = files[0]
	var tweakdata_file = File.new()
	tweakdata_file.open(tweakdata_path, File.READ)
	var tweakdata_content = tweakdata_file.get_as_text()
	
	var all_paths_final = ""
	
	for keys in pattern_key_search:
		progress_bar.max_value = tweakdata_content.length()
		var all_idx:PoolIntArray = []
		var found_idx = 0
		progress_bar.get_node("Label2").text = keys
		while true:
			found_idx = tweakdata_content.find(keys, found_idx + 1)
			if found_idx in all_idx:
				break
			else:
				all_idx.append(found_idx)
				progress_bar.value = found_idx
				yield(VisualServer, "frame_pre_draw")
		
		yield(get_tree().create_timer(1),"timeout")
		progress_bar.get_node("Label").text = "Stringing..."
		progress_bar.max_value = all_idx.size()
		progress_bar.value = 0
		var all_paths:PoolStringArray = []
		for idx in all_idx:
			if idx >= 0:
				var start:int = tweakdata_content.find("\"", idx )
				if start - idx < 50: # Check if the first quote is way too far
					var end:int = tweakdata_content.find("\"", start + 1)
					var result:String = tweakdata_content.substr(start + 1, end - start - 1)
					if !result in all_paths:
						for i in ignore_list():
							if !i in result:
								all_paths.append(result)
				progress_bar.value += 1
				yield(VisualServer, "frame_pre_draw")
		
		###
		dump_copy(all_paths, "C:/Program Files (x86)/Steam/steamapps/common/PAYDAY 2/assets/extract/", "res://Textures/VanillaDemoPatterns/")
		replace_as_png(all_paths, "C:/Program Files (x86)/Steam/steamapps/common/PAYDAY 2/assets/extract/", "res://Textures/VanillaDemoPatterns/")
		###
		
		yield(get_tree().create_timer(1),"timeout")
		progress_bar.get_node("Label").text = "Final strings..."
		progress_bar.max_value = all_paths.size()
		progress_bar.value = 0
		for i in all_paths:
			all_paths_final += i + "\n"
			progress_bar.value += 1
			yield(VisualServer, "frame_pre_draw")
	
	prints("FINISHED, TOOK MS.", OS.get_ticks_msec() - time)
	$PanelContainer/VBoxContainer/Label.text = all_paths_final



func dump_copy(paths:PoolStringArray, unit_path:String, output_path:String):
	print("Dumping copies")
	for file in paths:
		var file_out = File.new()
		if file_out.open(output_path + file.right(file.find_last("/")) + ".dds", File.WRITE) == OK:
			var file_in = File.new()
			if file_in.open(unit_path + file + ".texture.dds", File.READ) == OK:
				file_out.store_buffer( file_in.get_buffer(file_in.get_len()) )
			file_out.close()
	print("Done dumping copies")



func replace_as_png(paths:PoolStringArray, unit_path:String, output_path:String):
	print("Dumping copies")
	var res_path = "res://Textures/VanillaDemoPatterns/"
	for file in paths:
		var file_name = file.right(file.find_last("/"))
		var texture:ImageTexture = load(res_path + file_name + ".dds")
		var image:Image = texture.get_data()
		image.decompress()
		image.resize(256, 256, Image.INTERPOLATE_NEAREST)
		image.save_png(res_path + file_name.rstrip("." + file_name.get_extension()) + ".png")
	print("Done dumping copies")


func ignore_list():
	var list:PoolStringArray
	for i in ignored_dlc:
		list.append("/" + i + "/")
	return list
