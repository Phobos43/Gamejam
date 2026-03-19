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
	# Find the player in the tree
	for node in get_children():
		if node is Player:
			player = node
		elif node.has_signal("activated"):
			node.activated.connect(signal_activated)
	
	# Create and prepare a shadow
	shadow = load("res://Scenes/shadow.tscn").instantiate()
	shadow.hide()
	
	

func _physics_process(delta: float) -> void:
	if not is_player_dead:
		
		var p_state = PlayerState.new()
		p_state.player_pos = player.global_position
		p_state.is_crouched = player.is_crouched
		p_state.is_collidable = false
		
		var state = WorldState.new()
		state.player_state = p_state

func signal_activated(group_id, activation_time) -> void:
	if activation_time == -1:
		signal_off(group_id)
		return
	elif activation_time != 0:
		get_tree().create_timer(activation_time, false).timeout.connect(signal_off.bind(group_id))
	for node in get_tree().get_nodes_in_group("Dynamic Components"):
		if node.group_id_activation == group_id:
			node.toggled = true

func signal_off(group_id) -> void:
	for node in get_tree().get_nodes_in_group("Dynamic Components"):
		if node.group_id_activation == group_id:
			node.toggled = false
