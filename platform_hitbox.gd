extends Area2D
	
#signals for player interactions 
signal player_entered(platform) 
signal player_exited(platform)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect Area2D signals


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_platform_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("player_entered", self)
	print("player on platform")


func _on_platform_body_exited(body):
	if body.is_in_group("Player"):
		print("player left platform")
		emit_signal("player_exited", self)
