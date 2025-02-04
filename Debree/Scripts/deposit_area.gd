extends Area2D
var current_crate = 1
signal recived_crate
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _deposit_create():
	get_child(current_crate).show()
	current_crate += 1

func _on_Hanck_enter(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.Has_Crate:
		_deposit_create()
		
