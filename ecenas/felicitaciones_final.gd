extends CanvasLayer

const CHAR_READ_RATE = 0.05

var tween  # Variable global para el Tween
@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/Panel/HBoxContainer/Label/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/Panel/HBoxContainer/Label/Texto/End
@onready var label = $TextboxContainer/MarginContainer/Panel/HBoxContainer/Label/Texto

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

func _ready():
	print("Starting state: State.READY")
	hide_textbox()
	queue_text("¡Carter! ¡Lo lograste! La bomba ha sido desactivada y los rehenes están a salvo. La ciudad entera te debe su vida.")
	queue_text("La Mano de Érebo no pudo con nosotros, gracias a tu valentía y determinación. Eres un verdadero héroe.")
	queue_text("Tu trabajo aquí no será olvidado. Este es un día que quedará grabado en la historia de nuestra ciudad.")
	queue_text("En nombre del equipo, de la ciudad y de todos nosotros: ¡Gracias, Carter!")
	queue_text("Ahora regresa con nosotros. Aún tenemos una celebración pendiente para nuestro héroe.")


func _process(delta):
	match current_state:
		State.READY:
			if text_queue.size() > 0:
				display_text()
		State.READING:
			if Input.is_action_just_pressed("advance_dialog"):  # Detecta una acción configurada (por ejemplo, tecla 'v')
				if tween:
					tween.kill()  # Detiene la animación actual
				label.visible_characters = -1  # Muestra todo el texto
				end_symbol.text = "<-"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("advance_dialog"):  # Avanza al siguiente diálogo
				if text_queue.size() > 0:
					change_state(State.READY)  # Cambia al estado READY para mostrar el siguiente texto
				else:
					hide_textbox()  # Oculta el cuadro de texto si no hay más diálogos
					go_to_main_building()  # Llama a la función para cambiar de escena

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()

func display_text():
	tween = get_tree().create_tween()  # Crea un nuevo tween
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.visible_characters = 0  # Reinicia visible_characters a 0 para que el texto aparezca gradualmente
	change_state(State.READING)
	show_textbox()
	# Configurar la interpolación de la propiedad visible_characters
	tween.tween_property(label, "visible_characters", len(next_text), len(next_text) * CHAR_READ_RATE)
	tween.connect("finished", Callable(self, "on_tween_finished"))  # Conectar usando Callable
	end_symbol.text = "..."

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: State.READY")
		State.READING:
			print("Changing state to: State.READING")
		State.FINISHED:
			print("Changing state to: State.FINISHED")

func on_tween_finished():
	end_symbol.text = "<-"
	change_state(State.FINISHED)

# Nueva función para cambiar a la escena del edificio principal
func go_to_main_building():
	get_tree().change_scene_to_file("res://ecenas/menu_inicio.tscn")
