@tool
extends TextureComponent

signal toggle_group(id, length)

@export var group_id_activation : int = 0
@export var show_affecting_groups : bool = false

func _ready() -> void:
	refresh($Area2D/CollisionShape2D)
	$Area2D.body_entered.connect(body_entered)

var display_list = []

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if show_affecting_groups:
			for node in get_tree().get_nodes_in_group("Dynamic Components"):
				if node.group_id_activation == group_id_activation:
					var indicator = Line2D.new()
					indicator.points = [Vector2(0,0), node.position]
					indicator.add_to_group("Group indicators " + str(group_id_activation))
					add_child(indicator)
		else:
			for node in get_tree().get_nodes_in_group("Group indicator " + str(group_id_activation)):
				node.queue_free()
func body_entered(body:Node2D):
	toggle_group.emit(group_id_activation, -1)
	

func body_exited(body:Node2D):
	toggle_group.emit(group_id_activation, 0)
	
