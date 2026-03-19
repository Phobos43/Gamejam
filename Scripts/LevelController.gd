extends Node2D

# --- Nodes ---
var player : Player
var shadow : AnimatableBody2D

# --- World status ---
var is_player_dead := false

# --- Level status ---
var known_group_id : Dictionary = {}

# --- Class definitions
class PlayerState:
	var player_pos : Vector2
	var is_crouched : bool
	var is_collidable : bool

class WorldState:
	var player_state : PlayerState
	var group_id_status : Dictionary[int, bool]	

func _ready() -> void:
	for node in get_children():
		if node is Player:
			player = node
	
	shadow = load("res://Scenes/shadow.tscn").instantiate()


func _physics_process(delta: float) -> void:
	if not is_player_dead:
		var p_state = PlayerState.new()
		p_state.player_pos = player.global_position
		p_state.is_crouched = player.is_crouched
		p_state.is_collidable = false
		
		var state = WorldState.new()
		state.player_state = p_state
