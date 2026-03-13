@tool
extends TextureComponent

signal toggle_group(id, length)

@export var group_id_activation : int = 0
@export var show_affecting_groups : bool = false

func _ready() -> void:
	collision_node = $Area2D/CollisionShape2D
	$Area2D.body_entered.connect(body_entered)

var display_list = []

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if show_affecting_groups:
			print(toggle_group.get_connections())

func body_entered(body:Node2D):
	toggle_group.emit(group_id_activation, -1)
	

func body_exited(body:Node2D):
	toggle_group.emit(group_id_activation, 0)
	
