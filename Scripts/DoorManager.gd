@tool
extends StaticBody2D

@export var sprite : Texture2D
@export var sprite_scale : int
var platform_size : Vector2

func _ready() -> void:
	$Sprite2D.texture = sprite
	platform_size = sprite.get_size()
	var collision = RectangleShape2D.new()
	collision.size = platform_size
	$CollisionShape2D.shape = collision
