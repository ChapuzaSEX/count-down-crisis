extends Node2D


# Called when the node enters the scene tree for the first time.
func _on_button_pressed(): 
	get_tree().change_scene_to_file("res://ecenas/node_2d.tscn") 
	pass
func _on_button_2_pressed():
	
	get_tree().quit()
	pass	
