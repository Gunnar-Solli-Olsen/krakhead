extends CharacterBody2D




@export var SPEED := 300.0


	
	

func get_function_runtime(calleble : Callable):
	var start_timer = Time.get_ticks_msec()
	calleble.call()
	var end_time = Time.get_ticks_msec()
	return end_time -start_timer

func _physics_process(delta: float) -> void:
	var StateMachine = get_node("State Machine")
	
	StateMachine.move(self, delta)
