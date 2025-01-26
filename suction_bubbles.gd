extends Area2D

# Variables for suction
var suction_strength = 150  # Strength of the suction force
var suction_radius = 200    # Radius of suction effect
var particles: GPUParticles2D  # Reference to the particle system
var polygon_shape: CollisionPolygon2D  # Reference to the collision polygon
var water_level = 150       # Water level to control particle height

func _ready():
	# Validate nodes
	particles = $Particles
	polygon_shape = $CollisionPolygon2D

func _is_in_cone(target_position: Vector2) -> bool:
	if not polygon_shape or not polygon_shape.shape:
		return false
	return polygon_shape.shape.contains_point(to_local(target_position))

func _on_suction_bubbles_body_entered(body: Node2D):
	if body.name == "Player" and _is_in_cone(body.global_position):
		body.add_to_group("in_suction_cone")
		if body.has_method("start_suction_effect"):
			body.start_suction_effect(self)

func _on_suction_bubbles_body_exited(body: Node2D):
	if body.name == "Player":
		body.remove_from_group("in_suction_cone")
		if body.has_method("stop_suction_effect"):
			body.stop_suction_effect(self)

func emit_particles_from_polygon():
	if not polygon_shape or not polygon_shape.polygon:
		return
	for point in polygon_shape.polygon:
		emit_particle_at_position(point)

func emit_particle_at_position(local_point: Vector2):
	# Emit particles relative to the local position
	particles.position = to_local(local_point)
	particles.emitting = true

func _process(_delta):
	print("SuctionBubbles position:", global_position)
