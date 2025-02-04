extends Control

var exit = load("res://Menu.tscn")
var replay = load("res://main.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_packed(exit)
	pass # Replace with function body.


func _on_replay_pressed() -> void:
	get_tree().change_scene_to_packed(replay)
	pass # Replace with function body.
