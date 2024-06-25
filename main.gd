extends Node

@export var enemy_scene : PackedScene
@export var gem_scene : PackedScene
@export var summon_scene : PackedScene
@export var bubble_scene : PackedScene
@export var shuriken_scene : PackedScene
@export var main_menu : PackedScene

var ennemies_to_remove = []
var ennemies = []
var game_state = "play"
var target_enemy = Vector2.ZERO
var summons = []
var bubble_dmg = 1
var number_of_bubbles = 1
var summon_dmg = 3
var number_of_summons = 0
var game_level = 1
var score = 0
var shuriken_damage = 0
var number_of_shuriken = 0
var summon_timer = true




func _ready():
	
	new_game()
	
	for i in range(0, 0):
		var summon_instance = summon_scene.instantiate()
		summon_instance.position = $witch.global_position
		summon_instance.margin = i * 1.5
		summons.append(summon_instance)
		add_child(summon_instance)

func _physics_process(delta):
	$witch.damage_level = game_level
	$witch.game_state = game_state
	
	if game_state == "main_menu":
		$main_menu.show()
	
	if game_state == "play" :
		$hud/score.text = str(score)
		
		for ennemy in ennemies:
			seek_player(ennemy, delta)
			var direction = ($witch.position - ennemy.position).normalized()
			ennemy.update_state(direction.x)
			ennemy.update(bubble_dmg, summon_dmg, summons)
			
		remove_dead_enemies(ennemies)
		update_hud()
		
		if ennemies.size() > 0:
			target_enemy = ennemies[0].global_position
		
		# game over if the witch is dead
		if $witch.health <= 0:
			await get_tree().create_timer(0.6).timeout
			game_over()
			game_state = "over"
			$bg_song.stop()
		
		# find the nearest ennemy
		if ennemies.size():
			var nearest_distance = $witch.global_position.distance_to(ennemies[0].global_position)
			target_enemy = ennemies[0].global_position

			for e in ennemies:
				var new_distance = $witch.global_position.distance_to(e.global_position)
				if new_distance < nearest_distance:
					nearest_distance = new_distance
					target_enemy = e.global_position
		
		for summon in summons:
			var target = $witch.global_position
			summon.update(delta, target)
		
		# level up the player
		if $witch.experience >= $witch.exerience_to_level_up:
			$witch.level_up(game_level)
			game_state = "level up"
			game_level += 1
		
		# refresh summons
		if number_of_summons > 0 and len(summons) == 0 and summon_timer:
			$summon_timer.start()
			summon_timer = false 
			print("started summoning")
		
	if game_state == "over":
		var game_over_text = "Your score is : " + str(score)
		$gameover/message.text = game_over_text
		$gameover.show()

	if game_state == "level up":
		$levelup.show()	
		$"fire timer".stop()
		$bubble_timer.stop()
		$spawn_timer.stop()
		get_tree().call_group("bubbles", "queue_free")

func seek_player(ennemy, delta):
	var direction = ($witch.position - ennemy.position).normalized()
	ennemy.position += direction * 100 * delta

func spawn_ennemies(game_level):
	var ennemy = enemy_scene.instantiate()
	ennemy.max_health = game_level
	ennemy.health = ennemy.max_health
	ennemy.position = Vector2(randi_range(0, 3000), randi_range(0, 1500))
	add_child(ennemy)
	ennemies.append(ennemy)

func _on_summon_timer_timeout():
	spaw_summon(number_of_summons)
	summon_timer = true

func remove_dead_enemies(enemies):
	for e in enemies:
		if e.health <= 0: 
			enemies.erase(e)
			e.queue_free()
			$witch.experience += 1
			score += 1

func update_hud():
	$hud/health.max_value = $witch.max_health
	$hud/health.value = $witch.health
	$hud/xp.value = $witch.experience	
	$hud/xp.max_value = $witch.exerience_to_level_up	
	
func spawn_bubbles():
	var bubbles = []
	var facing = 1
	
	if $witch/Sprite2D.flip_h:
		facing = -1
	
	for i in range(0,number_of_bubbles):
		var bubble = bubble_scene.instantiate()
		bubble.position = $witch.global_position
		bubbles.append(bubble) 

	for bubble in bubbles:
		add_child(bubble)
		bubble.velocity.x *= facing
	
func spawn_shuriken():
	var shurikens = []
	for i in range(0, number_of_shuriken):
		var shuriken = shuriken_scene.instantiate()
		shuriken.position = $witch.global_position
		shurikens.append(shuriken)
	
	for shuriken in shurikens:
		add_child(shuriken)
		shuriken.velocity
	
func _on_spawn_timer_timeout():
	var number = int(game_level/2) + 1
	for i in range(0, number):
		spawn_ennemies(number)

func new_game():
	$witch.show()
	$witch.global_position = Vector2(300, 200)
	$witch.state = "idle"
	$witch.max_health = 100
	$witch.health = $witch.max_health
	$witch.experience = 0
	$witch.exerience_to_level_up = 3
	$witch.level = 0
	$gameover.hide()
	$witch/cooldown.start()
	$spawn_timer.start()
	$witch/CollisionShape2D.disabled = false
	$levelup.hide()
	game_state = "play"
	bubble_dmg = 1
	number_of_bubbles = 1
	summon_dmg = 2
	number_of_summons = 0
	summons = []
	$levelup.power_ups = [$levelup.bubble_button, $levelup.more_bubble, $levelup.heal, $levelup.healing]
	game_level = 1
	score = 0
	$bubble_timer.start()
	$bg_song.play()
	$main_menu.hide()
	
func game_over():
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("summons", "queue_free")
	get_tree().call_group("bubbles", "queue_free")
	$witch.hide()
	$witch/cooldown.stop()
	$spawn_timer.stop()
	$bubble_timer.stop()
	ennemies = []
	
func _on_gameover_play_again():
	new_game()
	print("new game")

func _on_fire_timer_timeout():
	"$witch.fire(target_enemy, $witch.bullet_count)"
	pass

func _on_levelup_power_up():
	# not needed anymore
	game_state = "play"
	$levelup.hide()
	$"fire timer".start()
	
	if $levelup.power_up_type == "heal":
		$witch.health += 20
		if $witch.health >= $witch.max_health:
			$witch.health = $witch.max_health
	if $levelup.power_up_type == "count":
		$witch.bullet_count += 1	
	if $levelup.power_up_type == "damage":
		$witch.bullet_dmg += 1

func _on_witch_witch_level_up():
	game_state = "level up"
	print("leveled up")

func _on_bubble_timer_timeout():
	spawn_bubbles()

func spaw_summon(x):
	for i in range(0, x):
		var summon_instance = summon_scene.instantiate()
		summon_instance.position = $witch.global_position
		summon_instance.margin = i * 1.5
		summons.append(summon_instance)
		add_child(summon_instance)
	
func _on_levelup_done():
	game_state = "play"
	$levelup.hide()
	$levelup.shuffle()
	$"fire timer".start()
	$bubble_timer.start()
	$spawn_timer.start()
	print($levelup.power_up_type)
	
	if $levelup.power_up_type == "bubble damage":
		bubble_dmg += 1
	if $levelup.power_up_type == "bubble amount":
		number_of_bubbles += 1
	if $levelup.power_up_type == "summon amount":
		if number_of_summons == 0:
			$levelup.power_ups.append($levelup.summon)
		number_of_summons += 1
	if $levelup.power_up_type == "summon damage":
		summon_dmg += 3
	if $levelup.power_up_type == "healing":
		$witch.health += 50
		if $witch.health >= $witch.max_health:
			$witch.health = $witch.max_health
	if $levelup.power_up_type == "heal":
		$witch.max_health += 30
		$witch.health += 30
	print($witch.max_health)
	
func _on_bg_song_finished():
	$bg_song.play()


