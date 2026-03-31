extends Button

@export_file("*.tscn") var target_scene

func _ready() -> void:
	pressed.connect(eee)

func eee():
	get_tree().change_scene_to_file(target_scene)
	
