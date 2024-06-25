extends CanvasLayer

signal start_game



func _on_start_button_pressed():
	$start_button/select_sound.play()
	start_game.emit()
	
func _on_start_button_mouse_entered():
	$start_button/hover_sound.play()

func _on_quit_button_pressed():
	$start_button/select_sound.play()
	
func _on_quit_button_mouse_entered():
	$start_button/hover_sound.play()
