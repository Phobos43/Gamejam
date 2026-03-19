@tool
extends ActivatorComponent

func _ready() -> void:
	refresh($Area2D/CollisionShape2D)
	$Area2D.body_entered.connect(body_entered)
	$Area2D.body_exited.connect(body_exited)

func _process(_delta: float) -> void:
	pass

func body_entered(body:Node2D):
	if body is not Player: return
	activate()



func body_exited(body:Node2D):
	if body is not Player: return
	if activation_time == 0:
		deactivate()
		
	
