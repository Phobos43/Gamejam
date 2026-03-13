@tool
extends TextureComponent

@export var group_id_activation : int = 0
@export var show_affecting_groups : bool = false

func _ready() -> void:
	refresh($Area2D/CollisionShape2D)
	$Area2D.body_entered.connect(body_entered)
	$Area2D.body_exited.connect(body_exited)

var display_list = []

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if show_affecting_groups:
			for node in get_tree().get_nodes_in_group("Dynamic Components"):
				if node.group_id_activation == group_id_activation:
					var indicator = Line2D.new()
					indicator.points = [Vector2(0,0), to_local(node.global_position)]
					indicator.add_to_group("Group indicators " + str(group_id_activation))
					add_child(indicator)
		else:
			for node in get_tree().get_nodes_in_group("Group indicators " + str(group_id_activation)):
				node.queue_free()

func body_entered(body:Node2D):
	print(body is Player)
	if body is not Player: return
	for node in get_tree().get_nodes_in_group("Dynamic Components"):
		if node.group_id_activation == group_id_activation:
			node.toggled = true
	

func body_exited(body:Node2D):
	if body is not Player: return
	for node in get_tree().get_nodes_in_group("Dynamic Components"):
		if node.group_id_activation == group_id_activation:
			node.toggled = false
	
