extends Area2D
signal hit # use for when ball hits paddle (not sure about name) 
@export var speed = 700
var screen_size
var start_pos: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	start_pos = Vector2(100, screen_size.y/2)
	
func start():
	position = start_pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # velocity default is zero
	if Input.is_action_pressed("move_up"):
		velocity.y-=1
	if Input.is_action_pressed("move_down"):
		velocity.y+=1
	
	if Input.is_action_pressed("move_left"):
		velocity.x-=1
	if Input.is_action_pressed("move_right"):
		velocity.x+=1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	else: 
		pass # add animation here if player is animated
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(_body: Node2D) -> void:
	hit.emit() # emit hit signal to ball? 
	$CollisionShape2D.set_deferred("disabled", true)
