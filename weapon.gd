extends Area2D

var Velocity = Vector2.ZERO

var game_state = "play"

func _process(delta):
	if game_state == "play":
		position += Velocity * delta
	
	
