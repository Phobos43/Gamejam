extends Node2D

@onready var alive: TileMapLayer = $Alive
@onready var dead: TileMapLayer = $Dead
@onready var player: CharacterBody2D = $Player
@onready var level_end: Area2D = $Level_End
@onready var shadow: CharacterBody2D = $Shadow
@onready var door: StaticBody2D = $Door

const player_start_pos = Vector2(90, 90)

var is_dead = false
var player_playback : Array[player_state] = []
var is_playing_back = false
var playback_frame = 0

var time_left = 30
var pressing_plate = false

class player_state:
	var position : Vector2
	var player_scale : Vector2
	var door_pos : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dead.hide()
	dead.collision_enabled = false
	level_end.body_entered.connect(level_complete)
	$Poison.body_entered.connect(player_died)
	$Pressure_plate.body_entered.connect(pressed_plate)
	$Pressure_plate.body_exited.connect(left_plate)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_left -= delta
	$Timer.text = "Time left: %s" % round(time_left)
	if not is_playing_back:
		var new_state = player_state.new()
		new_state.position = player.position
		new_state.door_pos = door.position
		new_state.player_scale = player.scale
		player_playback.append(new_state)
		
	level_end.rotate(2*PI*delta)
	
	if is_dead == true:
		alive.hide()
		alive.collision_enabled = false
		dead.show()
		dead.collision_enabled = true
	else:
		alive.show()
		alive.collision_enabled = true
		dead.hide()
		dead.collision_enabled = false
	
	if is_playing_back:
		print(playback_frame)
		if playback_frame < len(player_playback):
			shadow.show()
			shadow.position = player_playback[playback_frame].position
			shadow.scale = player_playback[playback_frame].player_scale
			playback_frame += 1
		else:
			shadow.hide()
			is_playing_back = false
			print("stopped")
	if is_playing_back:
		if playback_frame < len(player_playback):
			door.position = player_playback[playback_frame].door_pos
	else:
		if pressing_plate:
			door.position.y = move_toward(door.position.y, -100, 5)
		else:
			door.position.y = move_toward(door.position.y, 100, 5)

func player_died(body):
	if body == player:
		is_dead = true
		is_playing_back = true
		playback_frame = 0
		player.global_position = player_start_pos

func pressed_plate(body):
	if body == player:
		pressing_plate = true

func left_plate(body):
	if body == player:
		pressing_plate = false

func level_complete(body):
	if body == player:
		$"Level victory".show()
		player.hide()
		is_playing_back = false


func _on_button_pressed() -> void:
	get_tree().reload_current_scene.call_deferred()
