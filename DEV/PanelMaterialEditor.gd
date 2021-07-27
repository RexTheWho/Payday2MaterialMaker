extends PanelContainer

onready var spacial_renderer = $VBoxContainer/HBoxContainer/Result/SpacialRender

func _ready():
	pass

func change_current_material(idx:int, is_wear:bool):
	$VBoxContainer/Label.text = "Modifying Gradient #" + str(idx)
	if is_wear:
		$VBoxContainer/Label.text += " Wear"

func _on_GradientSlider_changed_gradient_idx(index):
	var slider_controller = $VBoxContainer/HBoxContainer/Controls/VBoxContainer/Sliders
	var slider_gradient = $VBoxContainer/HBoxContainer/Controls/VBoxContainer/GradientSlider
	var gradient:Gradient = slider_gradient.get_gradient()
	
	var color_data = {
		Red = gradient.get_color(index).r,
		Green = gradient.get_color(index).g,
		Blue = gradient.get_color(index).b,
		Pattern = gradient.get_color(index).a
	}
	slider_controller.set_data(color_data)


func _on_Sliders_updated_values(data):
	var slider_gradient = $VBoxContainer/HBoxContainer/Controls/VBoxContainer/GradientSlider
	var gradient:Gradient = slider_gradient.get_gradient()
	var new_color = Color(1,0,0,1)
	new_color.r = data["Red"]
	new_color.g = data["Green"]
	new_color.b = data["Blue"]
	new_color.a = data["Pattern"]
	gradient.set_color(slider_gradient.get_current_point(), new_color)
	
	spacial_renderer.set_new_material("Cubemap", data["Cubemap"])
	spacial_renderer.set_new_material("Gloss", data["Gloss"])
	spacial_renderer.set_new_material("Metalness", data["Metalness"])
	spacial_renderer.set_new_material("Specular", data["Specular"])


