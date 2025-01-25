extends CharacterBody2D

# Constants
const GRAVITY = 500
const JUMP_FORCE = -300
const SWIM_FORCE = -200  # This is the force when swimming up
const MAX_FALL_SPEED = 600
const SWIM_GRAVITY = 200
const SPEED = 200
const SUCTION_FORCE = 1000  # Stronger suction force to drag the player down
const SWIM_LIMIT = -500  # Make swimming force weaker when inside suction zone

# Variables
var is_in_water = false
var is_in_suction_cone = false

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

	# Handle swimming and gravity effects
	if is_in_water:
		# Swimming logic only if not in suction cone
		if is_in_suction_cone:
			# Apply suction force directly overriding swimming
			velocity.y += SUCTION_FORCE * delta  # Strong suction effect, no swimming allowed
		elif Input.is_action_pressed("ui_up"):
			velocity.y = SWIM_FORCE  # Normal swimming when not in suction
		else:
			velocity.y += SWIM_GRAVITY * delta
	else:
		# Apply gravity and jumping when out of water
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

# Called when the player enters the suction cone
func _on_suction_bubbles_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_in_suction_cone = true

# Called when the player exits the suction cone
func _on_suction_bubbles_body_exited(body: Node) -> void:
	if body.name == "Player":
		is_in_suction_cone = false
