extends Control




func _on_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://ecenas/menu_inicio.tscn")


func _on_volumen_pressed() -> void:
	get_tree().change_scene_to_file("res://ecenas/volumen.tscn")
