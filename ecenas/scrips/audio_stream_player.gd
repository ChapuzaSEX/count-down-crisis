extends AudioStreamPlayer

@onready var BGM =$"."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	BGM.play()
