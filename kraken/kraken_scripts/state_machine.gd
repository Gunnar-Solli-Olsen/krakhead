extends Node

	
func move(kraken: CharacterBody2D, delta):
	if not kraken.is_on_floor():
		kraken.velocity += kraken.get_gravity() * delta

	if Input.is_action_just_pressed("kraken suck"):
		print("Suuuck!")
		
	if Input.is_action_just_pressed("kraken special 1q"):
		print("special action q")
		
	if Input.is_action_just_pressed("kraken special 2e"):
		print("special action e")
	var direction := Input.get_axis("kraken move left", "kraken move right")
	
	if direction:
		kraken.velocity.x = direction * kraken.SPEED
	else:
		kraken.velocity.x = move_toward(kraken.velocity.x, 0, kraken.SPEED)

	kraken.move_and_slide()
