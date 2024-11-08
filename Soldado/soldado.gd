extends CharacterBody2D  

const SPEED = 150.0
const Correr = 2.0
const JUMP_VELOCITY = -250.0
const MAX_FALL_VELOCITY = 1000.0  # Velocidad de caída que causa la muerte
const DEATH_HEIGHT = 600.0  # Altura mínima desde la cual se considera que el personaje muere

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $AnimatedSprite2D
@onready var shoot_point = $Marker2D  # El nodo Position2D que marca el punto de disparo

# Cargar la escena de la bala
var bullet_scene = preload("res://ecenas/bala.tscn")  # Asegúrate de que la ruta sea correcta

var shoot_cooldown = 0.2
var time_since_last_shot = 0

# Nueva variable para la vida del personaje
var vida = 100  # Puedes ajustar el valor inicial según sea necesario

func animaciones(velocidad):
	if velocidad == 150:
		sprite.play("Caminar")
	elif velocidad == 300:
		sprite.play("Run")

func muerte():
	sprite.play("Muerte")

func _physics_process(delta):
	time_since_last_shot += delta

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		var velociad_corerr = SPEED
		if Input.is_action_pressed("ui_up"):
			velociad_corerr *= Correr
		velocity.x = direction * velociad_corerr
		animaciones(velociad_corerr)

		sprite.flip_h = direction < 0

	else:
		sprite.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Verificar si el personaje ha caído demasiado rápido o desde una altura peligrosa
	if position.y > DEATH_HEIGHT or velocity.y > MAX_FALL_VELOCITY:
		die()  # Llama a la función que maneja la muerte del personaje

	# Reproducir la animación y disparar si se mantiene presionado "shoot"
	if Input.is_action_pressed("ui_select"):
		if time_since_last_shot >= shoot_cooldown:
			shoot_bullet()
			time_since_last_shot = 0

		# Asegurarse de que la animación no se reinicie cada vez
		if sprite.animation != "Disparo":
			sprite.play("Disparo")

	# Si se suelta la tecla de disparo, volver a la animación normal
	else:
		if sprite.animation == "Disparo":
			sprite.play("Idle")  # Puedes cambiar a otra animación si no está quieto

	# Aquí es donde verificas si la vida ha llegado a 0
	if vida <= 0:
		muerte()
		die()  # Llama a la función que maneja la muerte del personaje

func shoot_bullet():
	# Instanciar la bala
	var bullet = bullet_scene.instantiate()

	# Posicionar la bala en el punto de disparo (GunPoint)
	bullet.position = shoot_point.global_position

	# Establecer la dirección de la bala
	if sprite.flip_h:
		bullet.direction = Vector2(-1, 0)  # Dispara hacia la izquierda
	else:
		bullet.direction = Vector2(1, 0)   # Dispara hacia la derecha

	# Añadir la bala a la escena
	get_parent().add_child(bullet)

# Función para manejar la muerte del personaje
func die():
	sprite.play("Muerte")

	# Crear un Timer y conectarlo a la señal de timeout
	var timer = Timer.new()
	timer.wait_time = 3.0  # Espera 3 segundos
	timer.one_shot = true  # Solo se ejecuta una vez
	timer.timeout.connect(on_timer_timeout)  # Conectar la señal a una función

	add_child(timer)  # Agregar el Timer a la escena
	timer.start()  # Iniciar el Timer

# Función que maneja el timeout del Timer
func on_timer_timeout():
	vida = 100  # Reiniciar la vida a su valor original
	get_tree().reload_current_scene()  # Recargar la escena actual para reiniciar

func _ready():
	add_to_group("player")

# Función para que el personaje reciba daño
func take_damage(damage_amount: int):
	vida -= damage_amount
	if vida <= 0:
		die()
