extends ProgressBar

var vidaMax:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vidaMax = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func disminuirVida(daño) -> void:
	value -= daño
