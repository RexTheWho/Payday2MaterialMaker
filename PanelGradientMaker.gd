extends PanelContainer

onready var sliders = $VBoxContainer/Sliders
var work_idx = 0

onready var gradients = [
	$VBoxContainer/HBoxContainer/PanelContainer2/PanelContainer/Gradients/GradientRGB.texture.gradient,
	$VBoxContainer/HBoxContainer/PanelContainer2/PanelContainer/Gradients/GradientAll.texture.gradient
]


func _ready():
	_update_spinbox_limit()
	_on_SpinBox_value_changed(0) # Dont keep this, temp


func _update_spinbox_limit():
	var limit = gradients[0].get_point_count()-1
	$VBoxContainer/HBoxContainer/SpinBox.max_value = limit
	$VBoxContainer/HBoxContainer/SpinBox.suffix = "/ " + str(limit)


func _on_SpinBox_value_changed(value):
	work_idx = value
	var swap_color = gradients[0].colors[work_idx]
	sliders.set_data({
		Red = swap_color.r,
		Green = swap_color.g,
		Blue = swap_color.b,
		Alpha = swap_color.a,
		Position = gradients[0].offsets[work_idx]
	})
	if work_idx == 0 or work_idx == gradients[0].get_point_count()-1:
		sliders.set_enabled("Position", false)
	else:
		sliders.set_enabled("Position", true)


func _on_Sliders_updated_values(data):
	var colors = Color( data["Red"], data["Green"], data["Blue"], data["Alpha"] )
	gradients[0].colors[work_idx] = colors
	colors.a = 1.0
	gradients[1].colors[work_idx] = colors
	
	var positions = data["Position"]
	for i in gradients:
		print(i.offsets)
		i.offsets[work_idx] = positions
