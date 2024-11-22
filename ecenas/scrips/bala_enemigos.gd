extends Area2D

# Velocidad de la bala
var speed = 800
# Dirección de la bala (se define en el script del personaje)
var direction = Vector2(1, 0)



func _process(delta):
	# Mover la bala en la dirección definida
	position += direction * speed * delta

# Esta función se llamará cuando la bala toque algo
func _on_body_entered(body):
	# Verifica si el objeto con el que colisiona pertenece al grupo "enemy"
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(10)  # Llama a la función take_damage en el objeto
			queue_free()  # Destruye la bala
