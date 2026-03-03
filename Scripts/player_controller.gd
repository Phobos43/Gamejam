extends CharacterBody2D
class_name Player

const GROUND_ACCELERATION = 200.0
const CROUCH_ACCELERATION = 80.0
const GROUND_FRICTION = 0.8
const AIR_SPEED = 200.0
const JUMP_VELOCITY = -800.0
const GRAVITY_MULTIPLIER = 2
const CROUCH_SIZE = 0.5

var is_crouched = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * GRAVITY_MULTIPLIER * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	is_crouched = Input.is_action_pressed("crouch")
	
	
	var direction := Input.get_axis("move_left", "move_right")
	
	if is_crouched:
		velocity.x += CROUCH_ACCELERATION * direction
		scale.y = lerpf(scale.y, CROUCH_SIZE, 0.5)
	else:
		velocity.x += GROUND_ACCELERATION * direction
		scale.y = lerpf(scale.y, 1, 0.5)
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	
	velocity.x *= GROUND_FRICTION

	move_and_slide()
