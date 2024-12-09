extends Control



func _on_button_pressed():
	get_tree().change_scene_to_file("res://ecenas/Edificio.tscn")

func _on_button_2_pressed():

	get_tree().quit()
	


func _on_opciones_pressed() -> void:
	get_tree().change_scene_to_file("res://ecenas/obpcion.tscn")
	
