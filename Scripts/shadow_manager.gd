extends AnimatableBody2D
class_name Shadow

@onready var standing_hb: CollisionShape2D = $StandingHB
@onready var crouching_hb: CollisionShape2D = $CrouchingHB
@onready var sprite_2d: Sprite2D = $Sprite2D

class PlayerState:
	var player_pos : Vector2
	var is_crouched : bool
	var is_collidable : bool

func set_state(player_state:PlayerState):
	show()
	global_position = player_state.player_pos
	standing_hb.disabled = true
	crouching_hb.disabled = true
	if player_state.is_crouched:
		sprite_2d.scale.y = lerpf(sprite_2d.scale.y, 0.5, 0.5)
		if player_state.is_collidable:
			crouching_hb.disabled = false
	else:
		sprite_2d.scale.y = lerpf(sprite_2d.scale.y, 0.8, 0.5)
		if player_state.is_collidable:
			standing_hb.disabled = false
