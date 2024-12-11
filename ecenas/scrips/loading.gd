extends Node2D

@onready var anime= $AnimationPlayer
@onready var tiempo = $Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anime.play("carga")
	tiempo.start()
	
	
	pass # Replace with function body.
	




func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://ecenas/segundo_nivel.tscn")
	pass # Replace with function body.
