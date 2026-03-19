extends AnimatableBody2D
class_name Shadow

@onready var standing_hb: CollisionShape2D = $StandingHB
@onready var crouching_hb: CollisionShape2D = $CrouchingHB
@onready var sprite_2d: Sprite2D = $Sprite2D


func set_state(player_state:Array):
	show()
	global_position = player_state[0]
	standing_hb.disabled = true
	crouching_hb.disabled = true
	if player_state[1]:
		sprite_2d.scale.y = lerpf(sprite_2d.scale.y, 0.5, 0.5)
		if player_state[2]:
			crouching_hb.disabled = false
	else:
		sprite_2d.scale.y = lerpf(sprite_2d.scale.y, 0.8, 0.5)
		if player_state[2]:
			standing_hb.disabled = false
