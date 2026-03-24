@tool
extends TextureComponent
class_name Hazard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh($Area2D/CollisionShape2D)
	
