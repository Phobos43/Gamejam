extends Node2D

# --- Nodes ---
var player : Player
var shadow : Shadow

# --- World status ---
var is_player_dead := false
var alive_playback_frame := 0
var alive_playback : Array[WorldState] = []

# --- Level status ---
var known_group_ids : Dictionary[int, bool] = {}
var grou


func player_died():
	if is_player_dead:
		get_tree().reload_current_scene.call_deferred()
	else:
		is_player_dead = true
		player.global_position = player_init_pos
		
