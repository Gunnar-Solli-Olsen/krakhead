extends CharacterBody2D

signal bubble_enter
signal bubble_exit


@export var SPEED := 300.0


	
	

func get_function_runtime(calleble : Callable):
	var start_timer = Time.get_ticks_msec()
	calleble.call()
	var end_time = Time.get_ticks_msec()
	return end_time -start_timer

func _physics_process(delta: float) -> void:
	var StateMachine = get_node("State Machine")
	
	StateMachine.move(self, delta)


func _on_suction_bubbles_body_entered(body: Node2D) -> void:
	bubble_enter.emit()
	pass # Replace with function body.


func _on_suction_bubbles_body_exited(body: Node2D) -> void:
	bubble_exit.emit()

	pass # Replace with function body.
