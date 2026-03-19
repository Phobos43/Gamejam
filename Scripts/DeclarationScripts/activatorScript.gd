extends TextureComponent
class_name ActivatorComponent

@export var group_id_activation : int = 0
@export var show_affecting_groups : bool = false
@export var activation_time : float = 1.0

@warning_ignore("unused_signal")
signal activated(group_id : int, activation_time : float)

func show_connections() -> void:
	for node in get_tree().get_nodes_in_group("Dynamic Components"):
		if node.group_id_activation == group_id_activation:
			var indicator = Line2D.new()
			indicator.points = [Vector2(0,0), to_local(node.global_position)]
			indicator.add_to_group("_Group indicators " + str(group_id_activation))
			add_child(indicator)

func hide_connections() -> void:
	for node in get_tree().get_nodes_in_group("_Group indicators " + str(group_id_activation)):
		node.queue_free()

func activate() -> void:
	activated.emit(group_id_activation, activation_time)
	
func deactivate() -> void:
	activated.emit(group_id_activation, -1)
