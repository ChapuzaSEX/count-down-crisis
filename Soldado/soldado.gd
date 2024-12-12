extends CharacterBody2D  

@export var nombre: String = "Alex Carter"
const SPEED = 150.0
const Correr = 2.0
const JUMP_VELOCITY = -250.0
const MAX_FALL_VELOCITY = 1000.0  # Velocidad de caída que causa la muerte
const DEATH_HEIGHT = 600.0  # Altura mínima desde la cual se considera que el personaje muere

@onready var sonBala = $"../AudioStreamPlayer2D"
@onready var sonHerir = $"../AudioStreamPlayer2D2"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $AnimatedSprite2D
@onready var shoot_point = $Marker2D  # El nodo Position2D que marca el punto de disparo

# Cargar la escena de la bala
var bullet_scene = preload("res://ecenas/bala.tscn")  # Asegúrate de que la ruta sea correcta

var shoot_cooldown = 0.4  # Ajusta la cadencia de disparo aquí (0.5 segundos entre disparos)
var time_since_last_shot = shoot_cooldown  # Inicia con el cooldown completo para evitar disparos al iniciar

# Nueva variable para la vida del personaje
var vida = 100  # Puedes ajustar el valor inicial según sea necesario

# Variable para controlar si está disparando
var is_shooting = false

func animaciones(velocidad):
	if velocidad == 150:
		sprite.play("Caminar")
	elif velocidad == 300:
		sprite.play("Run")

func muerte():
	sprite.play("Muerte")

func _physics_process(delta):
	time_since_last_shot += delta

	if is_shooting:
		# Si está disparando, no permitimos movimiento ni salto
		velocity.x = 0
		sprite.play("Disparo")
	else:
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
		die()

	# Disparar al mantener presionada "shoot" si no está disparando y el cooldown ha pasado
	if Input.is_action_just_pressed("ui_select") and not is_shooting and time_since_last_shot >= shoot_cooldown:
		is_shooting = true  # Activar el estado de disparo
		shoot_bullet()
		time_since_last_shot = 0  # Reiniciar el tiempo del cooldown

	# Liberar el estado de disparo cuando termine el cooldown
	elif is_shooting and time_since_last_shot >= shoot_cooldown:
		is_shooting = false
		sprite.play("Idle")

	# Aquí es donde verificas si la vida ha llegado a 0
	if vida <= 0:
		muerte()
		die()  # Llama a la función que maneja la muerte del personaje

func shoot_bullet():
	# Instanciar la bala
	var bullet = bullet_scene.instantiate()
	sonBala.play()

	# Posicionar la bala en el punto de disparo
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
	sonHerir.play()
	get_tree().get_nodes_in_group("BarraVida")[0].disminuirVida(10)
	if vida <= 0:
		die()
