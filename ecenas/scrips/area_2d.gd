extends Area2D  # Cambia a Area2D para manejar colisiones

@onready var sprite = $Sprite2D  # Asegúrate de que el nombre coincida con el nodo en la escena

# Lógica cuando el personaje colisiona con el ítem
func _on_body_entered(body):
	if body.is_in_group("player"):  # Verifica si el objeto que colisiona es el jugador
		body.vida -= 1  # Reduce la vida del jugador
		queue_free()  # Elimina el ítem después de recogerlo
