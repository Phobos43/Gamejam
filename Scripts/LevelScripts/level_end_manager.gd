extends Area2D
class_name LevelEnd

signal end_level

func _ready() -> void:
	self.body_entered.connect(area_triggered)

func area_triggered(body: Node2D):
	if body is Player:
		end_level.emit()
