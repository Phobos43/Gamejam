@tool
extends TextureComponent

enum Easing {
	Teleport,
	Linear,
	EaseOut
}

@export var group_id_activation : int = 0
@export var toggled : bool = false
@export var easing_mode : Easing
@export_category("Positions")
@export var toggled_position : Vector2
@export var initial_position := global_position

func _physics_process(delta: float) -> void:
	if toggled:
		movement_to(toggled_position)
	else:
		movement_to(initial_position)

func movement_to(target_pos: Vector2):
	if easing_mode == Easing.Teleport:
		global_position = target_pos
	elif easing_mode == Easing.Linear:
		global_position.move_toward(target_pos, 2)
	elif easing_mode == Easing.EaseOut:
		global_position.lerp(target_pos, 0.5)
