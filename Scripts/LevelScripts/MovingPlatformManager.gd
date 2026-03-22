@tool
extends Path2D

enum World {
	Constant,
	Alive,
	Dead
}

@onready var platform: AnimatableBody2D = $AnimatableBody2D

@export_category("MovingPlatform")
@export var loop := false
@export var speed := 2.0
@export var preview := false:
	set(val):
		preview = val
		if preview:
			if loop:
				set_process(true)
			else:
				$AnimationPlayer.speed_scale = speed
				$AnimationPlayer.play("move")
		else:
			$AnimationPlayer.stop()
			set_process(false)
			$PathFollow2D.progress = 0
@export_tool_button("Create default curve") var test = auto_add_curve

@export_category("TextureComponent")
@export var sprite : Texture2D:
	set(val):
		sprite = val
		if !platform: return
		platform.sprite = val
		platform.refresh(platform.collision_node)
@export var sprite_scale : float = 1:
	set(val):
		sprite_scale = abs(val)
		if !platform: return
		platform.sprite_scale = abs(val)
		platform.refresh(platform.collision_node)
@export var platform_state : World = World.Constant:
	set(val):
		platform_state = val
		if !platform: return
		platform.platform_state = val
		platform.update_platform_hitbox(true)

func auto_add_curve() -> void:
	# Creates an undo/redo editor object
	var undo_redo = EditorInterface.get_editor_undo_redo()
	
	# Start the action, but make the undo process backwards 
	# (last action done undoed first)
	undo_redo.create_action("Created a new default curve", UndoRedo.MERGE_DISABLE, null, true)
	
	# Delete each point of the curve
	for point_id in range(curve.point_count-1, -1, -1):
		var point_pos := curve.get_point_position(point_id)
		var point_in := curve.get_point_in(point_id)
		var point_out := curve.get_point_out(point_id)
		undo_redo.add_do_method(curve, &"remove_point", point_id)
		undo_redo.add_undo_method(curve, &"add_point", point_pos, point_in, point_out, point_id)
	
	# Add a "0" point
	undo_redo.add_do_method(curve, &"add_point", Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), 0)
	undo_redo.add_undo_method(curve, &"remove_point", 0)
	
	# Execute the action
	undo_redo.commit_action()


func _ready() -> void:
	preview = false
	print(loop)
	if not loop:
		$AnimationPlayer.play("move")
		$AnimationPlayer.speed_scale = speed
		if not Engine.is_editor_hint():
			set_process(false)
	else:
		set_process(true)
	
	@warning_ignore("unused_variable", "shadowed_variable")
	var platform: AnimatableBody2D = $AnimatableBody2D
	sprite = sprite
	sprite_scale = sprite_scale
	platform_state = platform_state
		
func _process(_delta: float) -> void:
	$PathFollow2D.progress += speed
