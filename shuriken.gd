extends CharacterBody2D

func _ready():
	velocity = Vector2(randi_range(-10, 10), randi_range(-10, 10))/10
	
func _process(delta):
	# update shuriken position
	position += velocity * 300 * delta
	
	# rotate shuriken 
	var degrees_per_second = -180.0
	rotate(delta * degrees_per_second)
