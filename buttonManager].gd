extends Button



func _ready() -> void:
	pressed.connect(was_pressed)

func was_pressed():
	Global.start_game()
	
