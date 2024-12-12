extends Node2D

@onready var personaje = $CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_escalera_12_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		personaje.position.x = 1369
		personaje.position.y = 465


func _on_escalera_22_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		personaje.position.x = -103
		personaje.position.y = 337


func _on_escalera_32_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		personaje.position.x = 1369
		personaje.position.y = 209


func _on_escalera_42_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		personaje.position.x = -103
		personaje.position.y = 81


func _on_escalera_52_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		personaje.position.x = 1369
		personaje.position.y = -47

func _on_escalera_62_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		personaje.position.x = -103
		personaje.position.y = -175

func _on_pasar_al_final_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.nombre == "Alex Carter":
		get_tree().change_scene_to_file("res://ecenas/felicitacionesFinal.tscn")
		
