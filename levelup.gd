extends CanvasLayer

signal done

@onready var bubble_button = $bubble_button
@onready var more_bubble = $more_bubble_button
@onready var heal = $heal_button
@onready var summon = $summon_button
@onready var more_summon = $more_summon_button
@onready var speed = $speed_button
@onready var healing = $heal
@onready var power_ups = [bubble_button, more_bubble, heal, healing]
var power_up_type 
var description_text = ""

func _ready():
	shuffle()
	'''var chosen_powerups = []
	while chosen_powerups.size() < 3:
		var index = randi_range(0, 5)
		var current_powerup = power_ups[index]
		if current_powerup not in chosen_powerups:
			chosen_powerups.append(current_powerup)
		
	chosen_powerups[0].position = Vector2(150,250)
	chosen_powerups[1].position = Vector2(550,250)
	chosen_powerups[2].position = Vector2(950,250)'''
	
func _process(delta):
	$description.text = description_text

func shuffle():
	var rng = RandomNumberGenerator.new()
	power_ups.shuffle()
	
	power_ups[0].position = Vector2(150, 250)
	power_ups[1].position = Vector2(550, 250)
	power_ups[2].position = Vector2(950, 250)
	
	for i in range(3, power_ups.size()):
		power_ups[i].position = Vector2(-500,-500)
	
	
func _on_bubble_button_pressed():
	power_up_type = "bubble damage"
	done.emit()
	$bubble_button/select.play()

func _on_more_bubble_button_pressed():
	power_up_type = "bubble amount"
	done.emit()
	$more_bubble_button/select.play()

func _on_heal_button_pressed():
	power_up_type = "heal"
	done.emit()
	$heal_button/select.play()

func _on_summon_button_pressed():
	power_up_type = "summon damage"
	done.emit()
	$summon_button/select.play()

func _on_more_summon_button_pressed():
	power_up_type = "summon amount"
	done.emit()
	$more_summon_button/select.play()

func _on_speed_button_pressed():
	power_up_type = "speed"
	done.emit()
	
func _on_heal_pressed():
	power_up_type = "healing"
	done.emit()
	$more_summon_button/select.play()
	
func _on_bubble_button_mouse_entered():
	description_text = "increase the damage of each bubble"
	$bubble_button/hover.play()
	
func _on_more_bubble_button_mouse_entered():
	description_text = "increase the number of bubbles fired"
	$more_bubble_button/hover.play()
	
func _on_heal_button_mouse_entered():
	description_text = "increase max health"
	$heal_button/hover.play()

func _on_summon_button_mouse_entered():
	description_text = "increases the damage of each summon"
	$summon_button/hover.play()
	
func _on_more_summon_button_mouse_entered():
	description_text = "increase the number of summons you have"
	$more_summon_button/hover.play()

func _on_speed_button_mouse_entered():
	description_text = "heals a small amount of health"
	$speed_button/hover.play()

func _on_heal_mouse_entered():
	description_text = "heals a small amount of health"
	$speed_button/hover.play()



