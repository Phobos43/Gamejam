extends Node2D
class_name TextureComponent

enum World {
	Constant,
	Alive,
	Dead
}

@export var sprite : Texture2D:
	set(val):
		sprite = val
		refresh(collision_node)
@export var sprite_scale : float = 1:
	set(val):
		sprite_scale = abs(val)
		refresh(collision_node)
@export var platform_state : World = World.Constant:
	set(val):
		platform_state = val
		update_platform_hitbox(true)
var platform_size : Vector2
var collision_node : CollisionShape2D

func _process(_delta: float) -> void:
	update_platform_hitbox(Global.is_player_alive)


func refresh(collision_param_node : CollisionShape2D) -> void:
	if !collision_param_node: return
	collision_node = collision_param_node
	$Sprite2D.texture = sprite
	$Sprite2D.scale = Vector2(sprite_scale, sprite_scale)
	if sprite:
		platform_size = sprite.get_size()
		var collision = RectangleShape2D.new()
		collision.size = platform_size * sprite_scale
		collision_node.shape = collision

func update_platform_hitbox(is_player_dead:bool):
	if !collision_node: return
	if platform_state == World.Constant:
		collision_node.disabled = false
		modulate = Color(1, 1, 1, 1)
		return
	if is_player_dead:
		collision_node.disabled = platform_state
		if platform_state == World.Alive:
			modulate = Color(1, 1, 1, 1)
		else:
			modulate = Color(1, 1, 1, 0.5)
	else:
		collision_node.disabled = !platform_state
		if platform_state == World.Dead:
			modulate = Color(1, 1, 1, 1)
		else:
			modulate = Color(1, 1, 1, 0.5)
