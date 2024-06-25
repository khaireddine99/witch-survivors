extends CharacterBody2D

var alive = true

func _ready():
	velocity = Vector2(randi_range(20, 100), randi_range(-10, 10))/50
	
func _physics_process(delta):
	update_bubble(delta)
	
func update_bubble(delta):	
	position += velocity * 300 * delta
