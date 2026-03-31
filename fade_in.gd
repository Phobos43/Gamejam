extends Control

func _ready() -> void:
	modulate = Color(0, 0, 0, 1)
	
func _process(delta: float) -> void:
	modulate = modulate.lightened(0.01)
