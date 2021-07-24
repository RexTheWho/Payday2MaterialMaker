extends TextureRect


func _ready():
	for i in texture.gradient.colors.size():
		prints( texture.gradient.offsets[i], "---", texture.gradient.colors[i] )
