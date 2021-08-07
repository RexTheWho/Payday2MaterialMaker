tool
extends ViewportContainer

onready var plaque_rot = $Viewport/Spacial/PlaqueRot
const turn_max = Vector2(200,120)
var once = true

onready var preview_model = $Viewport/Spacial/PlaqueRot/usp/usp

export(Texture) var base_gradient
export(Texture) var pattern = load("res://Textures/DefaultPatterns/pattern_default_df.texture.dds")
export(Texture) var pattern_gradient

# Pattern offset X Y
const usp_pattern_pos = Vector2(0.292392, 0)
# Pattern Tiling, Pattern Rotation, Pattern Spec Opacity
const usp_pattern_tweak = Vector3(1, 0, 0)



func _ready():
	print("3D Rendering")
	$Viewport.size = self.rect_size
	
#	set_mat_params( "texture_pattern", load("res://Textures/DefaultPatterns/pattern_default_df.texture.dds") )

	set_mat_params( "texture_base_gradient", base_gradient )
	set_mat_params( "texture_pattern", pattern )
	set_mat_params( "texture_pattern_gradient", pattern_gradient )
	set_mat_params( "pattern_scale", usp_pattern_tweak.x )
	set_mat_params( "pattern_offset", usp_pattern_pos )


func _process(_delta):
	if !Engine.is_editor_hint():
		var mouse = $Viewport.get_mouse_position()
		var size = $Viewport.size
		if is_mouse_inside(size, mouse):
			if get_node("Tween").is_active():
				get_node("Tween").stop_all()
			var amount = mouse / size - Vector2(0.5,0.5)
			plaque_rot.rotation_degrees.y = clamp(amount.x * turn_max.x, -turn_max.x, turn_max.x)
			plaque_rot.rotation_degrees.x = clamp(amount.y * turn_max.y, -turn_max.y, turn_max.y)
		elif !get_node("Tween").is_active():
			get_node("Tween").interpolate_property(plaque_rot, "rotation_degrees", plaque_rot.rotation_degrees, Vector3.ZERO, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
			get_node("Tween").start()


func set_texture(texture:ImageTexture):
	pass


func set_new_material(key:String, value:float):
	var mat:SpatialMaterial = $Viewport/Spacial/PlaqueRot/Plaque.get_active_material(0)
	if key == "Cubemap":
		print("set new material cubemap strength")
#		mat.set_roughness(-value)
	elif key == "Gloss":
		mat.set_clearcoat(-value)
		mat.set_clearcoat_gloss(-value)
	elif key == "Metalness":
		mat.set_roughness(lerp(0.1, 0.4, value))
	elif key == "Specular":
		mat.set_specular(-value)
	

func is_mouse_inside(size, mouse):
	return size.x > mouse.x and size.y > mouse.y and mouse.x > 0 and mouse.y > 0




func set_mat_params(param:String, value):
	prints(param, value)
	for i in preview_model.get_surface_material_count():
		var mat:Material = preview_model.get("material/" + str(i))
		mat.set("shader_param/" + param, value)


