extends Node2D

# --- Nodes ---
var player : Player
var shadow : Shadow
var level_end : LevelEnd

# --- World status ---
var alive_playback_frame := 0
var alive_playback : Array[WorldState] = []

# --- Level status ---
var known_group_ids : Dictionary[int, bool] = {}
var group_id_timed_activation : Dictionary[int, bool] = {}
var player_init_pos : Vector2

# --- Class definitions ---
class PlayerState:
	var player_pos : Vector2
	var is_collidable : bool
	func arrayify() -> Array:
		return [player_pos, is_collidable]

class WorldState:
	var player_state : PlayerState
	var group_id_status : Dictionary[int, bool]

func _ready() -> void:
	for node in get_children():
		# Find the player in the tree
		if node is Player:
			player = node
			player.player_died.connect(player_died)
			player_init_pos = player.global_position
		elif node is LevelEnd:
			level_end = node
			level_end.end_level.connect(next_level)
		# Connect activator node signals to the function
		# Also registers group id to dict
		elif node.has_signal("activated"):
			node.activated.connect(signal_activated)
			known_group_ids[node.group_id_activation] = false
		
		if node.is_class("TextureComponent"):
			node.update_platform_hitbox(true)
	
	group_id_timed_activation = known_group_ids.duplicate()
	# Create and prepare a shadow
	shadow = load("res://Scenes/shadow.tscn").instantiate()
	add_child(shadow)
	shadow.hide()
	
	

func _physics_process(_delta: float) -> void:
	if Global.is_player_alive:
		$BGAlive.show()
		$BGDead.hide()
		var p_state = PlayerState.new()
		p_state.player_pos = player.global_position
		p_state.is_collidable = false
		
		var state = WorldState.new()
		state.player_state = p_state
		# Make sure we duplicate to keep saved states unaffected from changes 
		state.group_id_status = known_group_ids.duplicate() 
		alive_playback.append(state)
		
	elif alive_playback_frame < len(alive_playback) - 1:
		$BGAlive.hide()
		$BGDead.shoe()
		var state = alive_playback[alive_playback_frame]
		shadow.set_state(state.player_state.arrayify())
		
		for key in state.group_id_status:
			if known_group_ids[key] or state.group_id_status[key]:
					known_group_ids[key] = true
			for node in get_tree().get_nodes_in_group("Dynamic Components"):
				if node.group_id_activation == key:
					node.toggled = state.group_id_status[key]
		
		alive_playback_frame += 1
	else:
		shadow.hide()

func signal_activated(group_id, activation_time) -> void:
	# activation_time = -1 indicates an "off" request
	if activation_time == -1:
		if group_id_timed_activation[group_id] != true:
			signal_off(group_id)
		return
	
	known_group_ids[group_id] = true
	
	# activation_time = 0 is an indefinite time 
	if activation_time != 0:
		group_id_timed_activation[group_id] = true
		get_tree().create_timer(activation_time, false).timeout.connect(signal_off.bind(group_id))
	
	for node in get_tree().get_nodes_in_group("Dynamic Components"):
		if node.group_id_activation == group_id:
			node.toggled = true

func signal_off(group_id) -> void:
	group_id_timed_activation[group_id] = false
	known_group_ids[group_id] = false
	for node in get_tree().get_nodes_in_group("Dynamic Components"):
		if node.group_id_activation == group_id:
			node.toggled = false

func player_died():
	if not Global.is_player_alive:
		Global.is_player_alive = true
		get_tree().reload_current_scene.call_deferred()
	else:
		Global.is_player_alive = false
		player.global_position = player_init_pos
		

func next_level():
	Global.next_level()
