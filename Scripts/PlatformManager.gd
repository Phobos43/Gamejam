@tool
extends StaticBody2D

@export var sprite : Texture2D:
	set(val):
		sprite = val
		refresh()
@export var sprite_scale : float = 1:
	set(val):
		sprite_scale = abs(val)
		refresh()
var platform_size : Vector2

func _ready() -> void:
	refresh()

func refresh():
	$Sprite2D.texture = sprite
	$Sprite2D.scale = Vector2(sprite_scale, sprite_scale)
	if sprite:
		platform_size = sprite.get_size()
		var collision = RectangleShape2D.new()
		collision.size = platform_size * sprite_scale
		$CollisionShape2D.shape = collision
