tool
extends GridContainer

signal updated_values(data)

export(Array) var required_sliders = [["Red", 0, 1, 0.01], ["Green", 0, 1, 0.01], ["Blue", 0, 1, 0.01], ["Alpha", 0, 1, 0.01]]

onready var tween = $Tween

var slider_data = {}

func _ready():
	for i in required_sliders:
		_build_slider(i)


func _build_slider(data):
	# Data
	slider_data[data[0]] = 0.75
	# Label
	var label = Label.new()
	label.name = "Label" + data[0]
	label.text = data[0]
	add_child(label)
	# Slider
	var slider = HSlider.new()
	slider.name = "Slider" + data[0]
	slider.min_value = data[1]
	slider.max_value = data[2]
	slider.step = data[3]
	slider.value = slider_data[data[0]]
	slider.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	if slider.connect("value_changed", self, "_updated_slider_value", [data[0]]) != OK:
		push_error("Failed to connect")
	add_child(slider)


func _updated_slider_value(value:float, id:String):
	prints(value, id)
	if !tween.is_active():
		slider_data[id] = value
		emit_signal("updated_values", slider_data)


func _update_slider_visuals():
	var tween_speed = 0.1
	for i in required_sliders:
		var node = get_node("Slider" + i[0])
		tween.interpolate_property( node, "value", node.value, slider_data[i[0]], tween_speed, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT )
	tween.start()


func get_data():
	return slider_data


func set_data(new_data:Dictionary):
	for i in new_data:
		slider_data[i] = new_data[i]
	_update_slider_visuals()


func random_values():
	for i in slider_data:
		print(i)
		slider_data[i] = rand_range(0,1)
	_update_slider_visuals()


func set_enabled(name_id:String, enabled:bool):
	var slider:HSlider = get_node("Slider" + name_id)
	slider.editable = enabled

