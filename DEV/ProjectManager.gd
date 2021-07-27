extends PanelContainer

signal export_project(name)

export(NodePath) var timer
export(NodePath) var tween
export(NodePath) var namer
export(NodePath) var icons
export(NodePath) var icons3D

const base_icon_tex = preload("res://Textures/ingame_gui_icon_base.png")
const start_draw = Vector2(60, 8)
const draw_area = Vector2(136, 110)

var current_gui_icon:Image

onready var unpainted = {
	gradient_mint = _new_gradient(),
	gradient_wear = _new_gradient(true)
}

onready var gradients = [
	{
	gradient_mint = _new_gradient(),
	gradient_wear = _new_gradient(true)
	}
]


func _input(event):
	if event.is_action_pressed("ui_left"):
		generate_from_gradients()
	if event.is_action_pressed("ui_right"):
		add_new_gradient_set()
		generate_from_gradients()

func _on_SaveButton_pressed():
	var output_loc = REF.get_project_path() + REF.default_icon_output + "/"
	var output_name:String = "unnamed_skin"
	if get_node(namer).text != "":
		output_name = get_node(namer).text.strip_escapes()
		output_name = output_name.replace( " ", "_")
	
	var SAV_DDS = load("res://Tools/export_dds.gd").new()
	if SAV_DDS.save_dds_from_image(current_gui_icon, output_loc + output_name) != OK:
		push_error("Failed to save base_gradient!!")
	
	emit_signal("export_project", output_name)


func generate_from_gradients():
	print(gradients)
	
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
			color *= gradient["gradient_mint"].interpolate(1-get_ratiof(y, draw_area.y))
			
			current_gui_icon.lock()
			current_gui_icon.set_pixelv(draw, color)
	
	var new_tex = ImageTexture.new()
	new_tex.create_from_image(current_gui_icon, 32)
	get_node(icons).texture = new_tex
	get_node(icons3D).set_texture(new_tex)


func add_new_gradient_set():
	gradients.append({
		gradient_mint = _new_gradient(),
		gradient_wear = _new_gradient(true)
	})


func _new_gradient(is_wear = false):
	var gradient = Gradient.new()
	var minmax = [0.5, 1.0]
	if !is_wear:
		gradient.set_color(0, Color(rand_range(minmax[0], minmax[1]),rand_range(minmax[0], minmax[1]),rand_range(minmax[0], minmax[1])))
		gradient.set_color(1, Color(rand_range(minmax[0], minmax[1]),rand_range(minmax[0], minmax[1]),rand_range(minmax[0], minmax[1])))
	else:
		gradient.set_color(0, Color.gray)
		gradient.set_color(1, Color.darkgray)
	return gradient

func get_ratiof(a:float, b:float):
	return a / (b - 1)

