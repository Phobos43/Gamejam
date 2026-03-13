@tool
extends TextureComponent

enum Easing {
	Teleport,
	Linear,
	EaseOut
}

enum Positionset {
	None,
	InitialPos,
	ToggledPos
}

@export var group_id_activation : int = 0
@export var toggled : bool = false
@export var easing_mode : Easing
@export_group("Positions")
@export var toggled_position : Vector2
@export var initial_position := global_position
@export var set_positions : Positionset = Positionset.None

func _ready() -> void:
	refresh($CollisionShape2D)

func _physics_process(_delta: float) -> void:
	if set_positions == Positionset.None:
		if toggled:
			movement_to(toggled_position)
		else:
			movement_to(initial_position)
	else:
		if set_positions == Positionset.InitialPos:
			initial_position = global_position
		elif set_positions == Positionset.ToggledPos:
			toggled_position = global_position
			
			
func movement_to(target_pos: Vector2):
	if easing_mode == Easing.Teleport:
		global_position = target_pos
	elif easing_mode == Easing.Linear:
		global_position.x = move_toward(global_position.x, target_pos.x, 4)
		global_position.y = move_toward(global_position.y, target_pos.y, 4)
	elif easing_mode == Easing.EaseOut:
		global_position.x = lerpf(global_position.x, target_pos.x, 0.1)
		global_position.y = lerpf(global_position.y, target_pos.y, 0.1)
