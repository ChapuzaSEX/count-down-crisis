extends Area2D

# Velocidad de la bala
var speed = 800
# Dirección de la bala (se define en el script del personaje)
var direction = Vector2(1, 0)
# Distancia máxima que la bala puede recorrer
@export var max_distance = 315
# Posición inicial de la bala
var start_position = Vector2()

func _ready():
	# Almacenar la posición inicial de la bala
	start_position = global_position

func _process(delta):
	# Mover la bala en la dirección definida
	position += direction * speed * delta

	# Verificar si la bala ha recorrido más de la distancia máxima
	if global_position.distance_to(start_position) > max_distance:
		queue_free()  # Destruye la bala

# Esta función se llamará cuando la bala toque algo
func _on_body_entered(body):
	# Verifica si el objeto con el que colisiona pertenece al grupo "enemy"
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(10)  # Llama a la función take_damage en el objeto
		queue_free()  # Destruye la bala
