extends Node

@export var bubble_scene : PackedScene
var bubbles = []

func spawn():
	for i in range(0,20):
		var bubble = bubble_scene.instantiate()
		bubble.position = $position.position
		bubbles.append(bubble) 

	for bubble in bubbles:
		add_child(bubble)	
	
	
func _on_timer_timeout():
	spawn()
