extends CharacterBody2D

var level = 1
var health = 3
var max_health = 0
var take_damage = true


func _ready():
	pass

func update_state(x):
	if x != 0:
		$Sprite2D.flip_h = x < 0

func dead():
	$AnimationPlayer.play("death")	

func update_health():
	$health_bar.max_value = max_health
	$health_bar.value = health

func enemy_bullet_collision(bubble_damage, summon_damage, summons):
	var collided_summon
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("bullets"):
			health -= 1
			collision.get_collider().queue_free()
			
		if collision.get_collider().is_in_group("bubbles"):
			print("hit by bubble")
			health -= bubble_damage
			collision.get_collider().queue_free()
			$particles.emitting = true
			$HitFlashAnimationPlayer.play("hit flash")
			
		if collision.get_collider().is_in_group("summons") and take_damage:
			var summon = collision.get_collider()
			print("hit by summon")
			health -= summon_damage
			collided_summon = collision.get_collider()
			collided_summon.queue_free()
			summons.erase(collided_summon)
				
			$HitFlashAnimationPlayer.play("hit flash")

	
	
func update(bubble_damage, summon_damage, summons):
	update_health()
	enemy_bullet_collision(bubble_damage, summon_damage, summons)

func _on_collision_timer_timeout():
	$CollisionShape2D.set_deferred("disabled", false)
	print("can hit again")
	take_damage = true

