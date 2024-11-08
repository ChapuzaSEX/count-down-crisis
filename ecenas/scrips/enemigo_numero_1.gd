extends CharacterBody2D

const SPEED = 100.0  # Velocidad de patrulla
const RAYCAST_DISTANCE = 200.0  # Distancia de detección del jugador
const GRAVITY = 800.0  # Gravedad para el NPC
const SHOOT_COOLDOWN = 1.0  # Tiempo entre disparos

var pursuing = false  # Estado de persecución
var cooldown_timer = SHOOT_COOLDOWN  # Temporizador de disparo
var player_reference = null  # Referencia al jugador detectado
var vida = 30  # Vida del NPC

@onready var raycast_left = $RayCast_izquierda  # Raycast a la izquierda
@onready var raycast_right = $RayCast_derecha  # Raycast a la derecha
@onready var shoot_point = $ShootPoint  # Punto desde donde dispara el NPC
@onready var bullet_scene = preload("res://ecenas/bala_enemigos.tscn")  # Pre-carga de la escena de bala

func _ready():
	add_to_group("enemy")  # Agregar el NPC al grupo "enemy"
	# Configurar los raycasts para detectar en direcciones opuestas
	raycast_left.target_position = Vector2(-RAYCAST_DISTANCE, 0)
	raycast_right.target_position = Vector2(RAYCAST_DISTANCE, 0)

func _physics_process(delta: float) -> void:
	# Aplica gravedad si no está en el suelo
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0

	# Control de patrulla cuando no persigue
	if not pursuing:
		$AnimatedSprite2D.play("Run")  # Animación de caminar
		velocity.x = SPEED if !$AnimatedSprite2D.flip_h else -SPEED
	else:
		$AnimatedSprite2D.play("Run")  # Mantener animación al perseguir

	# Actualiza los raycasts y el temporizador de disparo
	raycast_left.force_raycast_update()
	raycast_right.force_raycast_update()
	cooldown_timer -= delta

	# Detectar al jugador o cambiar de dirección al topar con pared
	check_player_detection_and_distance()
	if is_on_wall():
		change_direction()

	# Cambia a animación de idle cuando esté quieto
	if velocity.x == 0:
		$AnimatedSprite2D.play("Idle")

	# Mueve el NPC
	move_and_slide()

func check_player_detection_and_distance():
	# Detección del jugador a través de los raycasts
	print("Chequeando detección del jugador")
	if raycast_left.is_colliding() and raycast_left.get_collider().is_in_group("player"):
		print("Jugador detectado a la izquierda")
		player_reference = raycast_left.get_collider()
		start_pursuit(-1)
	elif raycast_right.is_colliding() and raycast_right.get_collider().is_in_group("player"):
		print("Jugador detectado a la derecha")
		player_reference = raycast_right.get_collider()
		start_pursuit(1)
	else:
		pursuing = false
		player_reference = null

func start_pursuit(direction: int):
	# Inicia la persecución si el jugador está dentro de la distancia del RayCast
	if player_reference:
		var distance_to_player = global_position.distance_to(player_reference.global_position)
		if distance_to_player <= RAYCAST_DISTANCE:
			pursuing = true
			velocity.x = direction * SPEED * 1.5  # Incrementa la velocidad al perseguir
			print("Persecución iniciada")
		else:
			pursuing = false  # Detiene si el jugador sale de rango

	# Disparar si está persiguiendo y el temporizador ha terminado
	if pursuing and cooldown_timer <= 0:
		shoot_bullet(direction)
		cooldown_timer = SHOOT_COOLDOWN

func shoot_bullet(direction: int):
	# Instancia y dispara la bala en la dirección del jugador
	var bullet = bullet_scene.instantiate()
	bullet.position = shoot_point.global_position

	# Asegurarse de que la dirección de la bala se ajuste al movimiento
	bullet.direction = Vector2(direction, 0).normalized()
	
	get_tree().current_scene.add_child(bullet)
	$AnimatedSprite2D.play("Disparo")  # Cambia a la animación de disparo
	print("Bala disparada en dirección: ", direction)

func change_direction():
	# Cambia de dirección al topar con una pared
	velocity.x = -velocity.x
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h  # Cambia la orientación del sprite
	print("Dirección cambiada")

# Función para recibir daño
func take_damage(amount: int):
	vida -= amount  # Reduce la vida del NPC
	print("Vida restante: ", vida)
	if vida <= 0:
		die()  # Llama a la función de muerte si la vida llega a 0

# Función para manejar la muerte del NPC
func die():
	queue_free()  # Elimina el NPC de la escena
	print("El NPC ha muerto")
