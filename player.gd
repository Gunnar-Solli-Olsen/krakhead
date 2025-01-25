extends CharacterBody2D

# Constants
@export var GRAVITY = 500
@export var JUMP_FORCE = -300
@export var MAX_FALL_SPEED = 600
@export var SPEED = 250
@export var SWIM_FORCE = 400
@export var SWIM_GRAVITY = 100
@export var SWIM_SPEED = 150

var min_x = 0
var max_x = 715
var min_y = 0
var max_y = 420
# Variables
var is_in_water = false
# switch to play water enter animation, 
# sounds and slow player falling speed down

var entered_water = false 

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


	
	
	if global_position.y > 150:
		is_in_water = true
		if (not entered_water):
			velocity.y*=1/2
			entered_water = true
		# Swimming logic
	else:
		is_in_water = false
		entered_water = false
	
	if is_in_water: # if player is swimming
		if Input.is_action_pressed("ui_up"):
			velocity.y += (SWIM_GRAVITY - SWIM_FORCE) * delta
			print("swimforce: ", (SWIM_GRAVITY - SWIM_FORCE) * delta)
		else:
			velocity.y += SWIM_GRAVITY * delta
			print("fallforce: ", (SWIM_GRAVITY) * delta)
				# Apply horizontal speed
		velocity.x = direction.x * SWIM_SPEED # this is different if the player is in water

		
	else:
		# Apply gravity and jumping
		velocity.y += GRAVITY * delta
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = JUMP_FORCE
		velocity.x = direction.x * SPEED # this is different if the player is in water


	# Limit fall speed
	velocity.y = clamp(velocity.y, -MAX_FALL_SPEED, MAX_FALL_SPEED)
	
	
		# Get the current position of the CharacterBody3D node
	var current_position = global_position
	
	# Clamp the x position
	current_position.x = clamp(current_position.x, min_x, max_x)
	current_position.y = clamp(current_position.y, min_y, max_y)

	# Apply the new position back to the CharacterBody3D
	global_position = current_position
	# Apply movement
	move_and_slide()

# Update the water state when the player enters water
func _on_water_body_entered(body: Node2D) -> void:
	pass
	#if body.name == "Player":
	#	is_in_water = true

# Update the water state when the player exits the water
func _on_water_body_exited(body: Node2D) -> void:
	pass
	#if body.name == "Player":
	#	is_in_water = false
