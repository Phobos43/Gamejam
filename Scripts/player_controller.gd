extends CharacterBody2D
class_name Player

const GROUND_ACCELERATION = 100.0
const GROUND_FRICTION = 0.8

const AIR_SPEED = 50.0

const JUMP_VELOCITY = -800.0
const GRAVITY_MULTIPLIER = 2

const STAND_SIZE = 0.4
const CROUCH_SIZE = 0.2


"""The coyotee time in frames"""
const COYOTE_TIME = 5

const JUMP_BUFFER = 5

var coyote_time = COYOTE_TIME
var jump_buffer = JUMP_BUFFER
var last_y_vel = 0

var current_animation := Animations.Idle
var tick = 0
var is_facing_right := true
enum Animations {
	Idle,
	Walk,
	Jumping,
	Falling
}

@onready var ans = [$Idle, $JumpAscend, $JumpFalling, $Walk]

signal player_died



func _ready() -> void:
	$Area2D.area_entered.connect(body_entered)

func _physics_process(delta: float) -> void:
	
	is_player_crushed()
	
	
	# Add the gravity.
	if is_on_floor():
		coyote_time = COYOTE_TIME
	else:
		if coyote_time > 0:
			coyote_time -= 1
		velocity += get_gravity() * GRAVITY_MULTIPLIER * delta

	if jump_buffer > 0:
		jump_buffer -= 1
	
	if Input.is_action_just_pressed("jump") and jump_buffer == 0:
		jump_buffer = 5
		
	if jump_buffer > 0 and (is_on_floor() or coyote_time > 0):
		coyote_time = 0
		jump_buffer = 0
		velocity.y = JUMP_VELOCITY
		$JumpParticles.emitting = true
		
	var direction := Input.get_axis("move_left", "move_right")
	
	velocity.x += GROUND_ACCELERATION * direction
	$CrouchingHB.disabled = true
	$StandingHB.disabled = false
	
	velocity.x *= GROUND_FRICTION
	move_and_slide()
	
	
	if velocity.y < 0:
		switch_to_animation(Animations.Jumping)
	elif velocity.y > 0:
		switch_to_animation(Animations.Falling)
	elif direction != 0:
		switch_to_animation(Animations.Walk)
	else :
		switch_to_animation(Animations.Idle)
	if abs(direction) != direction:
		is_facing_right = true
	elif direction != 0:
		is_facing_right = false
	for node in ans:
		node.flip_h = is_facing_right
	
	
	move_and_slide()

	if last_y_vel - velocity.y > 5 and velocity.y == 0:
		$LandParticles.emitting = true
		
	last_y_vel = velocity.y
	
func body_entered(body: Node2D):
	if body.get_parent() is Hazard: 
		player_died.emit()

func is_player_crushed():
	# Not proud of this, but I'm running out of time
	var collisions = {
		"DownStanding" : false,
		"UpStanding" : false,
		"DownCrounching" : false,
		"UpCrouching" : false,
		"Right" : false,
		"Left" : false
	}
	
	for node in get_children():
		if node is RayCast2D:
			collisions[node.name] = node.is_colliding()
	
	if collisions["Right"] and collisions["Left"]:
		player_died.emit()
	else:
		if collisions["UpStanding"] and collisions["DownStanding"]:
				player_died.emit()

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
	
