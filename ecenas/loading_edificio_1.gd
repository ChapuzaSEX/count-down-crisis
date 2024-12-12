extends Node2D

@onready var anime = $AnimationPlayer
@onready var tiempo = $Timer

func _ready() -> void:
	anime.play("carga")
	tiempo.start()  # Inicia el temporizador

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://ecenas/Edificio.tscn")
