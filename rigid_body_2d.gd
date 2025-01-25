extends StaticBody2D  # Use Node2D if you don't need physics interactions

# Exported variables for customization in the editor
@export var start_position: Vector2
@export var end_position: Vector2
@export var speed: float = 100.0  # Speed of the platform



# Internal state
var moving_to_end: bool = true  # Direction of movement

func _ready():
	# Ensure the platform starts at the correct position
	position = start_position

func _physics_process(delta):
	# Determine the target position
	var target_position = end_position if moving_to_end else start_position

	# Move the platform toward the target position
	#position = position.move_toward(target_position, speed * delta)
	position = lerp(position, target_position, speed * delta)


	# Check if the platform reached the target position
	if position.distance_to(target_position) < 1.0:
		moving_to_end = not moving_to_end  # Reverse direction
		
