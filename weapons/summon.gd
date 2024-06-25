extends CharacterBody2D

var d = 0.0
var radius = 150
var speed = 2
var mouse_position 
var margin = 10

func _physics_process(delta):
	pass

func update(delta, target):
	d += delta
	
	position = Vector2(
		sin(d * speed + margin) * radius,
		cos(d * speed + margin) * radius
	) + target
	
	
