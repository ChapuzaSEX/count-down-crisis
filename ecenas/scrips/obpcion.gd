extends Control


# Called when the node enters the scene tree for the first time.


func _on_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://ecenas/menu_inicio.tscn")
