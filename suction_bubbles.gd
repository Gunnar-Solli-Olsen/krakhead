extends Area2D

# Variables for suction
var suction_strength = 150  # Strength of the suction force
var suction_radius = 200    # Radius of suction effect
var particles: GPUParticles2D  # Reference to the particle system
var polygon_shape: CollisionPolygon2D  # Or Polygon2D
var water_level = 150 # Water level to control particle height


func _is_in_cone(position: Vector2) -> bool:
	print("entered suction")
	if polygon_shape and polygon_shape.shape:
		var local_position = to_local(position)
		return polygon_shape.shape.contains_point(local_position)
	return false


# Function to emit particles from points inside the polygon
func emit_particles_from_polygon(polygon_points: Array):
	# Iterate through each point in the polygon and emit a particle
	for point in polygon_points:
		emit_particle_at_position(point)

# Emit particle at given position inside the polygon
func emit_particle_at_position(position: Vector2):
	# Set the particle to emit from the specific position
	particles.position = position
	particles.emitting = true


func _on_suction_bubbles_body_entered(body: Node2D) -> void:
	print("entered cone")
	if body.name == "Player" and _is_in_cone(body.global_position):
		body.add_to_group("in_suction_cone")
		body.start_suction_effect(self)


func _on_suction_bubbles_body_exited(body: Node2D) -> void:
	print("left cone")
	if body.name == "Player" and not _is_in_cone(body.global_position):
		body.remove_from_group("in_suction_cone")
		body.stop_suction_effect(self)
