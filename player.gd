extends CharacterBody2D

# Constants
const GRAVITY = 500
const JUMP_FORCE = -300
const SWIM_FORCE = -200
const MAX_FALL_SPEED = 600
const SWIM_GRAVITY = 200
const SPEED = 200

# Variables
var is_in_water = false

func _ready():
	# Ensure the player is rendered above the water (higher value)
	z_index = 1  # Default value is 0; this puts the player above water if water has Z-index 0

func _physics_process(delta):
	# Horizontal movement
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1

	# Apply horizontal speed
	velocity.x = direction.x * SPEED

	if is_in_water:
		# Swimming logic
		if Input.is_action_pressed("ui_up"):
			velocity.y = SWIM_FORCE
		else:
			velocity.y += SWIM_GRAVITY * delta
	else:
		# Apply gravity and jumping
		velocity.y += GRAVITY * delta
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = JUMP_FORCE

	# Limit fall speed
	velocity.y = clamp(velocity.y, -MAX_FALL_SPEED, MAX_FALL_SPEED)

	# Apply movement
	move_and_slide()

# Update the water state when the player enters water
func _on_water_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_in_water = true

# Update the water state when the player exits the water
func _on_water_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_in_water = false
