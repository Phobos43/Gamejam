extends HSlider

func _ready() -> void:
	value = Global.volume

func _process(_delta: float) -> void:
	Global.volume = value
