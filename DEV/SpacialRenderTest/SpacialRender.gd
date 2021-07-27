extends ViewportContainer

onready var plaque_rot = $Viewport/Spacial/PlaqueRot
const turn_max = Vector2(60,50)
var once = true


func _ready():
	print("3D Rendering")
	$Viewport.size = self.rect_size


func _process(_delta):
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
	$Viewport/Spacial/PlaqueRot/Plaque.get_active_material(0).set_texture(0, texture)


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
