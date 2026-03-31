extends AnimatableBody2D
class_name Shadow

@onready var standing_hb: CollisionShape2D = $StandingHB

var current_animation := Animations.Idle
var tick = 0
enum Animations {
	Idle,
	Walk,
	Jumping,
	Falling
}

@onready var ans = [$Idle, $JumpAscend, $JumpFalling, $Walk]


func set_state(player_state:Array):
	show()
	global_position = player_state[0]
	standing_hb.disabled = true
	if player_state[1]:
		standing_hb.disabled = false
	switch_to_animation(player_state[2])
	for node in ans:
		node.flip_h = player_state[3]


func switch_to_animation(target_anim : Animations):
	if target_anim == Animations.Idle:
		if current_animation == Animations.Idle:
			if tick == 0:
				ans[0].frame = (ans[0].frame + 1) % 3
				tick = 5
			else: 
				tick -= 1
		else:
			for node in ans:
				node.hide()
			ans[0].show()
			tick = 0
	elif target_anim == Animations.Walk:
		if current_animation == Animations.Walk:
			if tick == 0:
				ans[3].frame = (ans[3].frame + 1) % 6
				tick = 5
			else:
				tick -= 1
		else:
			for node in ans:
				node.hide()
			ans[3].show()
			tick = 0
	elif target_anim == Animations.Jumping:
		if current_animation != Animations.Jumping:
			for node in ans:
				node.hide()
			ans[1].show()
	elif target_anim == Animations.Falling:
		if current_animation != Animations.Falling:
			for node in ans:
				node.hide()
			ans[2].show()
	current_animation = target_anim
	
