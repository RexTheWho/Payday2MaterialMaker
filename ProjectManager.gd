extends PanelContainer

signal export_project(name)

export(NodePath) var timer
export(NodePath) var tween
export(NodePath) var namer
export(NodePath) var icons

const base_icon_tex = preload("res://Textures/ingame_gui_icon_base.png")
const start_draw = Vector2(60, 8)
const draw_area = Vector2(136, 110)

var current_gui_icon:Image
var use_test_gradients = true

func _ready():
	print(icons)
	test_with_test_gradients()

func _input(event):
	if event.is_action_pressed("ui_left"):
		test_with_test_gradients()

func test_with_test_gradients():
	randomize()
	if use_test_gradients:
		var gradients_test_list = []
		for _i in range(randi()%4+1):
			var new_gradient = Gradient.new()
			for _ap in range(randi()%3 + 2):
				new_gradient.add_point(rand_range(0,1), Color(rand_range(0,1),rand_range(0,1),rand_range(0,1)))
			gradients_test_list.append(new_gradient)
		
		# Nasty ass temp stuff
		var load_delay = .5
		get_node(timer).connect("timeout", self, "generate_from_gradients", [gradients_test_list])
		get_node(timer).start(load_delay)
		get_node(tween).interpolate_property(get_node(icons).get_node("Fake"), "modulate", Color(1,1,1,0), Color(1,1,1,1), load_delay/4)
		get_node(tween).interpolate_property(get_node(icons).get_node("Fake/Loading"), "value", 0, 100, load_delay)
		get_node(tween).start()
#		generate_from_gradients( gradients_test_list )


func generate_from_gradients(gradients:Array):
	# TEMP
	var load_delay = 1.0
	get_node(timer).disconnect("timeout", self, "generate_from_gradients")
	get_node(tween).interpolate_property(get_node(icons).get_node("Fake"), "modulate", Color(1,1,1,1), Color(1,1,1,0), load_delay/4)
	
	prints("Gradients:", gradients.size())
	
	current_gui_icon = base_icon_tex.get_data()
	
	var draw = Vector2.ZERO
	for y in range(draw_area.y):
		draw.y = y + start_draw.y
		
		for x in range(draw_area.x):
			draw.x = x + start_draw.x
			
			var gradient_group = lerp(0.0, (gradients.size() / draw_area.x), x)
			var gradient = gradients[int(gradient_group)]
			
			current_gui_icon.lock()
			var color = current_gui_icon.get_pixelv(draw)
			color *= gradient.interpolate(1-get_ratiof(y, draw_area.y))
			
			current_gui_icon.lock()
			current_gui_icon.set_pixelv(draw, color)
	
	var new_tex = ImageTexture.new()
	new_tex.create_from_image(current_gui_icon, 32)
	get_node(icons).texture = new_tex
	

func get_ratiof(a:float, b:float):
	return a / (b - 1)


func _on_SaveButton_pressed():
	var output_loc = REF.get_project_path()
	var output_name:String = "unnamed_skin"
	if get_node(namer).text != "":
		output_name = get_node(namer).text.strip_escapes()
		output_name = output_name.replace( " ", "_")
	
	var SAV_DDS = load("res://Tools/export_dds.gd").new()
	if SAV_DDS.save_dds_from_image(current_gui_icon, output_loc + output_name) != OK:
		push_error("Failed to save base_gradient!!")
	
	emit_signal("export_project", output_name)

