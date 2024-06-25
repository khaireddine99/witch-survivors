extends CharacterBody2D

signal witch_level_up

@export var bullet_scene : PackedScene
var level = 0
var speed = 350
var Velocity = Vector2.ZERO
var max_health = 100
var health = max_health
var experience = 0
var exerience_to_level_up = 3   
var state = "idle"
var game_state = "play"
var damage_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if game_state == "play":
		Velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		position += Velocity * speed * delta

		if state == "hurt":
			$AnimationPlayer.play("hit")	
		elif  state == "death":
			$AnimationPlayer.play("death")

		else:
			if Velocity.length() > 0:
				$AnimationPlayer.play("run")
			else:
				$AnimationPlayer.play("idle")
		if Velocity.x != 0:
			$Sprite2D.flip_h = Velocity.x < 0 	
		
		move_and_slide()
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider().is_in_group("enemies"):
				if state != "hurt":
					state = "hurt"
					health -= 10 * damage_level
					await get_tree().create_timer(0.6).timeout
					state = "idle"
					
		if health <= 0:
			state = "death"
			$CollisionShape2D.disabled = true
		
		 # Clamp player position within boundaries
		var player_pos = global_position
		player_pos.x = clamp(player_pos.x, 0, 2900)
		player_pos.y = clamp(player_pos.y, 0, 1500)
		global_position = player_pos

# this function is not in use anymore 
func fire(enemy_position, bullet_count):
	var bullet_instances = []
	var directions = []
	var facing = 1
	if $Sprite2D.flip_h:
		facing = -1
	var global_position = $node.global_position
	
	for i in range(bullet_count):
		var bullet_instance = bullet_scene.instantiate()
		bullet_instance.position = global_position
		var target_position = $node.get_node("position"+str(i+1)).global_position
		directions.append((target_position - global_position).normalized())
		bullet_instance.Velocity = directions[i] * speed * facing
		bullet_instances.append(bullet_instance)
	
	for bullet_instance in bullet_instances:
		get_parent().add_child(bullet_instance)

func level_up(game_level):
	exerience_to_level_up =  game_level + 3
	experience = 0
	print("current level:", game_level)

