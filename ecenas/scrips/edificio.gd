extends Node2D

@onready var personaje = $CharacterBody2D
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_escalera_1_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		personaje.position.x = 1369
		personaje.position.y = 465


func _on_escalera_2_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		personaje.position.x = -103
		personaje.position.y = 337


func _on_escalera_3_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		personaje.position.x = 1369
		personaje.position.y = 209


func _on_escalera_4_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		personaje.position.x = -103
		personaje.position.y = 81


func _on_escalera_5_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		personaje.position.x = 1369
		personaje.position.y = -47


func _on_escalera_6_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		personaje.position.x = -103
		personaje.position.y = -175


func _on_escalera_7_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		personaje.position.x = 1369
		personaje.position.y = -303


func _on_pasar_segundo_nivel_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		get_tree().change_scene_to_file("res://ecenas/segundo_nivel.tscn")
