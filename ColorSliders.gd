extends GridContainer

signal updated_rgba_values(colors)

var RGBA:Color = Color(0.1, 0.9, 0.1, 0.75)

export(String) var red_name = "RED"
export(String) var green_name = "GREEN"
export(String) var blue_name = "BLUE"
export(String) var alpha_name = "ALPHA"

onready var red_label = $RedLabel
onready var green_label = $GreenLabel
onready var blue_label = $BlueLabel
onready var alpha_label = $AlphaLabel

onready var red_slider = $RedSlider
onready var green_slider = $GreenSlider
onready var blue_slider = $BlueSlider
onready var alpha_slider = $AlphaSlider

onready var tween = $Tween


func _ready():
	red_label.text = red_name
	green_label.text = green_name
	blue_label.text = blue_name
	alpha_label.text = alpha_name
	_update_slider_visuals()


func _update_slider_visuals():
	var tween_speed = 0.1
	tween.interpolate_property( red_slider, "value", red_slider.value, RGBA.r, tween_speed, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT )
	tween.interpolate_property( green_slider, "value", green_slider.value, RGBA.g, tween_speed, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT  )
	tween.interpolate_property( blue_slider, "value", blue_slider.value, RGBA.b, tween_speed, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT  )
	tween.interpolate_property( alpha_slider, "value", alpha_slider.value, RGBA.a, tween_speed, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT  )
	tween.start()


func _updated_slider_value(value:float, index:int):
	if !tween.is_active():
		if index == 0:
			RGBA.r = value
		elif index == 1:
			RGBA.g = value
		elif index == 2:
			RGBA.b = value
		elif index == 3:
			RGBA.a = value
		emit_signal("updated_rgba_values", RGBA)


func set_color(value:Color):
	RGBA = value
	_update_slider_visuals()
	emit_signal("updated_rgba_values", RGBA)


func random_color():
	RGBA.r = rand_range( 0,1 )
	RGBA.g = rand_range( 0,1 )
	RGBA.b = rand_range( 0,1 )
	RGBA.a = rand_range( 0,1 )
	_update_slider_visuals()
	emit_signal("updated_rgba_values", RGBA)


