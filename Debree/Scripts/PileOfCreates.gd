extends Area2D

var current_crate = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _crate_taken():
	print(current_crate)
	get_child(1).queue_free()
	Global.num_of_crates -= 1
	current_crate += 1
	
func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if Global.num_of_crates != 0:
		_crate_taken()
	
	
