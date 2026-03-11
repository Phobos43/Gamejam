@tool
extends StaticBody2D

@export var sprite : Texture2D
@export var sprite_scale : int = 1
var platform_size : Vector2

func _ready() -> void:
	$Sprite2D.texture = sprite
	$Sprite2D.scale = Vector2(sprite_scale, sprite_scale)
	platform_size = sprite.get_size()
	var collision = RectangleShape2D.new()
	collision.size = platform_size * sprite_scale
	$CollisionShape2D.shape = collision
