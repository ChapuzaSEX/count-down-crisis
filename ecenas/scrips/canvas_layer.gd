extends CanvasLayer


func _physics_process(delta):
	if Input.is_action_just_pressed("pausa"):
		get_tree().paused = not get_tree().paused
		$ColorRect.visible = not $ColorRect.visible
		$Label.visible = not $Label.visible
		$salir.visible = not $salir.visible

func _on_salir_pressed():
	get_tree().change_scene_to_file("res://ecenas/menu_inicio.tscn")
