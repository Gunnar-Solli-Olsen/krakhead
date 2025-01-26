extends GPUParticles2D

func _process(delta):
	# Get the Kraken's global position
	if get_parent() != null:
		var kraken_position = get_parent().global_position
		
		# Update the particle node's position to match the Kraken's position
		global_position = kraken_position
