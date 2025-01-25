extends Area2D
	
#signals to player.gd, functions are defined there 
signal player_entered(platform) 
signal player_exited(platform)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect Area2D signals


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
