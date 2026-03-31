extends Node

class PlayerState:
	var player_pos : Vector2
	var is_crouched : bool
	var is_collidable : bool

var is_player_alive := true
var current_scene = null
var current_level = 0

var level_paths_list = []

# Nodes
var music_player : AudioStreamPlayer

func _ready():
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)
	level_paths_list = _get_levels_from_folder("res://Scenes/Levels/")
	
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	change_music(load("res://Assets/titlescreendemofinal.wav"))

func start_game():
	change_music(load("res://Assets/main_game.wav"))


func change_music(new_music : AudioStreamWAV):
	music_player.stop()
	music_player.stream = new_music
	music_player.play()
	
func next_level():
	is_player_alive = true
	
	current_level += 1
	var path = level_paths_list[current_level]
	_deferred_goto_scene.call_deferred(path)

func _deferred_goto_scene(path):
	current_scene.free()

	var s = ResourceLoader.load(path)

	current_scene = s.instantiate()

	get_tree().root.add_child(current_scene)

	get_tree().current_scene = current_scene

func _get_levels_from_folder(path: String) -> Array[String]:
	var dir = DirAccess.open(path)
	var result: Array[String] = []

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tscn"):
				result.append(path + "/" + file_name)
			file_name = dir.get_next()

		dir.list_dir_end()

	return result
