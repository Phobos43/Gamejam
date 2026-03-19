extends CharacterBody2D
class_name Player

const GROUND_ACCELERATION = 200.0
const CROUCH_ACCELERATION = 80.0
const GROUND_FRICTION = 0.8

const AIR_SPEED = 200.0

const JUMP_VELOCITY = -800.0
const GRAVITY_MULTIPLIER = 2

const STAND_SIZE = 0.8
const CROUCH_SIZE = 0.5


"""The coyotee time in frames"""
const COYOTE_TIME = 5

const JUMP_BUFFER = 5

var is_crouched = false
var coyote_time = COYOTE_TIME
var jump_buffer = JUMP_BUFFER

var is_op = false

func _physics_process(delta: float) -> void:
	
	# --- OP script start (to remove) ---
	if Input.is_action_just_pressed("OP"):
		is_op = !is_op
	if is_op:
		$CrouchingHB.disabled = false
		$StandingHB.disabled = false
		var movement = Input.get_vector("move_left", "move_right", "jump", "crouch")
		position += movement * 20
		return
	# --- OP script end ---
	
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
		
	is_crouched = Input.is_action_pressed("crouch")
	var direction := Input.get_axis("move_left", "move_right")
	
	if is_crouched:
		velocity.x += CROUCH_ACCELERATION * direction
		$Sprite2D.scale.y = lerpf($Sprite2D.scale.y, CROUCH_SIZE, 0.5)
		$CrouchingHB.disabled = false
		$StandingHB.disabled = true
	else:
		velocity.x += GROUND_ACCELERATION * direction
		$Sprite2D.scale.y = lerpf($Sprite2D.scale.y, STAND_SIZE, 0.5)
		$CrouchingHB.disabled = true
		$StandingHB.disabled = false
	
	velocity.x *= GROUND_FRICTION
	move_and_slide()
