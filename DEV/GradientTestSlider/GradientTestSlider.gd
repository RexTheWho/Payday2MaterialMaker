extends PanelContainer

signal changed_gradient_idx(index)
signal changed_gradient_offset(offset)

export(NodePath) var gradient_path
export(NodePath) var slider_path
export(NodePath) var slider_ghost0_path
export(NodePath) var slider_ghost1_path
export(NodePath) var spinbox_path

var gradient_node:Gradient
var slider_node:HSlider
var slider_ghost0_node:HSlider
var slider_ghost1_node:HSlider
var spinbox_node:SpinBox


func _ready():
	gradient_node = get_node(gradient_path).texture.gradient
	slider_node = get_node(slider_path)
	slider_ghost0_node = get_node(slider_ghost0_path)
	slider_ghost1_node = get_node(slider_ghost1_path)
	spinbox_node = get_node(spinbox_path)
	spinbox_node.max_value = gradient_node.get_point_count()-1
	slider_node.value = gradient_node.offsets[spinbox_node.value]
	_update_slider_ghost_positions(spinbox_node.value)


func _on_SpinBox_value_changed(value):
#	slider_node.editable = !is_gradient_edge(value)
	slider_node.value = gradient_node.offsets[value]
	emit_signal("changed_gradient_idx", value)
	_update_slider_ghost_positions(value)


func _update_slider_ghost_positions(value):
	if value > 0:
		slider_ghost0_node.value = gradient_node.offsets[value-1]
	else:
		slider_ghost0_node.value = 0
		
	if value < spinbox_node.max_value-1:
		slider_ghost1_node.value = gradient_node.offsets[value+1]
	else:
		slider_ghost1_node.value = 1


func _on_HSlider_value_changed(value):
	if is_slider_in_bounds(value):
		slider_node.value = gradient_node.offsets[get_current_point()]
	else:
		gradient_node.offsets[get_current_point()] = value
	emit_signal("changed_gradient_offset", value)


func is_gradient_edge(value):
	return value == 0 or value == gradient_node.get_point_count()


func get_current_point():
	return spinbox_node.value


func get_gradient():
	return gradient_node


func is_slider_in_bounds(value):
	# Min = 0
	# Max = gradient_node.offsets.size()
	if get_current_point() > 0 and value < gradient_node.offsets[get_current_point()-1]:
		return true
	
	elif gradient_node.offsets.size() < get_current_point() or value >= gradient_node.offsets[clamp(get_current_point()+1, 0, gradient_node.offsets.size()-1)]:
		return true
	
	else:
		return false
