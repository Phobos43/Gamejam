extends CharacterBody2D
class_name Player

const GROUND_ACCELERATION = 200.0
const CROUCH_ACCELERATION = 80.0
const GROUND_FRICTION = 0.8

const AIR_SPEED = 200.0

const JUMP_VELOCITY = -800.0
const GRAVITY_MULTIPLIER = 2

const STAND_SIZE = 0.2
const CROUCH_SIZE = 0.1


"""The coyotee time in frames"""
const COYOTE_TIME = 5

const JUMP_BUFFER = 5

var is_crouched = false
var coyote_time = COYOTE_TIME
var jump_buffer = JUMP_BUFFER

signal player_died

var is_op = false
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	$Area2D.area_entered.connect(body_entered)

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
		
	is_crouched = Input.is_action_pressed("crouch")
	var direction := Input.get_axis("move_left", "move_right")
	
	if is_crouched:
		velocity.x += CROUCH_ACCELERATION * direction
		sprite.scale.y = lerpf(sprite.scale.y, CROUCH_SIZE, 0.5)
		$CrouchingHB.disabled = false
		$StandingHB.disabled = true
	else:
		velocity.x += GROUND_ACCELERATION * direction
		sprite.scale.y = lerpf(sprite.scale.y, STAND_SIZE, 0.5)
		$CrouchingHB.disabled = true
		$StandingHB.disabled = false
	
	velocity.x *= GROUND_FRICTION
	move_and_slide()
	
	
	if velocity.y < 0:
		sprite.play("jump_ascend")
	elif velocity.y > 0:
		sprite.play("jump_fall")
	elif direction != 0:
		sprite.play("walk")
	else :
		sprite.play("idle")
	if abs(direction) != direction:
		sprite.flip_h = true
	elif direction != 0:
		sprite.flip_h = false

	
	move_and_slide()

		
	
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
		if is_crouched:
			if collisions["UpCrouching"] and collisions["DownCrounching"]:
				player_died.emit()
		else:
			if collisions["UpStanding"] and collisions["DownStanding"]:
				player_died.emit()
