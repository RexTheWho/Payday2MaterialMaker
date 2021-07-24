extends PanelContainer

func _on_rand_pressed():
	$List/Sliders.random_values()


func _on_Sliders_updated_values(data):
	print(data)
