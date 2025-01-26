extends CharacterBody2D
signal on_platform
# Constants
@export var GRAVITY = 500
@export var JUMP_FORCE = -300
@export var MAX_FALL_SPEED = 600
@export var SPEED = 250
@export var SWIM_FORCE = 400
@export var SWIM_GRAVITY = 100
@export var SWIM_SPEED = 150

const SUCTION_FORCE = 1000  # Stronger suction force to drag the player down
const SWIM_LIMIT = -500  # Make swimming force weaker when inside suction zone
@onready var _animated_sprite = $Sprite

var min_x = 0
var max_x = 715
var min_y = 0
var max_y = 420
# Variables
var is_in_water = false
var is_in_suction_cone = false
var is_on_platform = false
# switch to play water enter animation, 
# sounds and slow player falling speed down
var entered_water = false 

var current_platform : StaticBody2D = null
var platform_velocity: Vector2 = Vector2.ZERO


func _ready():
	# Ensure the player is rendered above the water (higher value)
	z_index = 1  # Default value is 0; this puts the player above water if water has Z-index 0
	var platforms = get_tree().get_nodes_in_group("platform")


func _physics_process(delta):
	# Horizontal movement
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		_animated_sprite.flip_h = true
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		_animated_sprite.flip_h = false
		

	# If player enters water turn on water physics
	if global_position.y > 150:
		is_in_water = true

		if (not entered_water): # entering water should lower speed 
			velocity.y*=4/6
			entered_water = true
		# Swimming logic
	else:
		is_in_water = false
		entered_water = false
	
	if is_in_water: # if player is swimming
		if is_in_suction_cone:
			# Apply suction force directly overriding swimming
			velocity.y += SUCTION_FORCE * delta  # Strong suction effect, no swimming allowed
			if (not $MakingBubble.playing):
				$MakingBubble.play(0)
		elif Input.is_action_pressed("ui_up"):
			if ($MakingBubble.playing):
				$MakingBubble.stop()
			velocity.y += (SWIM_GRAVITY - SWIM_FORCE) * delta
			#print("swimforce: ", (SWIM_GRAVITY - SWIM_FORCE) * delta)
		else:
			$MakingBubble.stop()

			velocity.y += SWIM_GRAVITY * delta
			#print("fallforce: ", (SWIM_GRAVITY) * delta)
				# Apply horizontal speed
		velocity.x = direction.x * SWIM_SPEED # this is different if the player is in water
			
	else:	# Apply gravity and jumping while above water 

		velocity.y += GRAVITY * delta
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = JUMP_FORCE
		velocity.x = direction.x * SPEED # this is different if the player is in water


	# Limit fall speed
	velocity.y = clamp(velocity.y, -MAX_FALL_SPEED, MAX_FALL_SPEED)
	
	if (is_on_platform): # change this to be difference between platform and player 
		$SwimmingPlayer.stop()
		if (direction.x == 0):
			_animated_sprite.play("idle")
			$WalkingOnPlatform.stop()	

		else:
			_animated_sprite.play("walk")
			if (not $WalkingOnPlatform.playing):
				$WalkingOnPlatform.play(0)

		if (Input.is_action_pressed("SOS")):
			print("sos")
		# Get the current position of the CharacterBody3D node
	else:
		_animated_sprite.play("swim")
	var current_position = global_position
	
	# Clamp the x position
	current_position.x = clamp(current_position.x, min_x, max_x)
	#current_position.y = clamp(current_position.y, min_y, max_y)

	# Apply the new position back to the CharacterBody3D
	global_position = current_position
	# Apply movement
	move_and_slide()

	# Check for the moving platform


# Update the water state when the player enters water
func _on_water_body_entered(body: Node2D) -> void:
	print("player entered water")
	$SwimmingPlayer.play(0.45)
	$splash.play(0)
	pass
	#if body.name == "Player":
	#	is_in_water = true

# Update the water state when the player exits the water
func _on_water_body_exited(body: Node2D) -> void:
	print("player exited water")

	pass
	#if body.name == "Player":
	#	is_in_water = false
	
func _on_platform_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("player on platform")
		is_on_platform = true
		#emit_signal("player_entered", self)

func _on_platform_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		print("player left platform")
		is_on_platform = false
		$WalkingOnPlatform.stop()

		#emit_signal("player_exited", self)

# Called when the player enters the suction cone
func _on_suction_bubbles_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_in_suction_cone = true

# Called when the player exits the suction cone
func _on_suction_bubbles_body_exited(body: Node) -> void:
	if body.name == "Player":
		is_in_suction_cone = false
