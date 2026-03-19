@tool
extends ActivatorComponent

var timer : float

func _ready() -> void:
	refresh($Area2D/CollisionShape2D)

func _process(_delta: float) -> void:
	# not Engine.is_editor_hint() is required to avoid getting 
	# bombarded with "action doesn't exist" errors
	
	if not Engine.is_editor_hint() and Input.is_action_just_pressed("interact"):
		for node in $Area2D.get_overlapping_bodies():
			if node is Player:
				activate()
				break 
				# We break the loop for performance, 
				# there's only 1 player
