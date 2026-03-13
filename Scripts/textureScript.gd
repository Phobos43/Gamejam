extends Node
class_name TextureComponent

@export var sprite : Texture2D:
	set(val):
		sprite = val
		refresh()
@export var sprite_scale : float = 1:
	set(val):
		sprite_scale = abs(val)
		refresh()
var platform_size : Vector2

"""Updates the size of the hitbox and the sprite2D according to the texture and the scaling"""
func refresh() -> void:
	$Sprite2D.texture = sprite
	$Sprite2D.scale = Vector2(sprite_scale, sprite_scale)
	if sprite:
		platform_size = sprite.get_size()
		var collision = RectangleShape2D.new()
		collision.size = platform_size * sprite_scale
		$CollisionShape2D.shape = collision
