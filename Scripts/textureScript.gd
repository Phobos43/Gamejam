extends Node2D
class_name TextureComponent

@export var sprite : Texture2D:
	set(val):
		sprite = val
		refresh(collision_node)
@export var sprite_scale : float = 1:
	set(val):
		sprite_scale = abs(val)
		refresh(collision_node)
var platform_size : Vector2

var collision_node : CollisionShape2D
func refresh(collision_param_node) -> void:
	if !collision_param_node: return
	collision_node = collision_param_node
	$Sprite2D.texture = sprite
	$Sprite2D.scale = Vector2(sprite_scale, sprite_scale)
	if sprite:
		platform_size = sprite.get_size()
		var collision = RectangleShape2D.new()
		collision.size = platform_size * sprite_scale
		collision_node.shape = collision
