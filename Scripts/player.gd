extends CharacterBody2D

var speed : float = 150

var nearest_enemy : CharacterBody2D
var nearest_enemy_distance : float = INF

var health : float = 100 :
	set (value):
		health = value
		%HealthBar.value = value

func _physics_process(delta: float) -> void:
	if is_instance_valid(nearest_enemy):
		nearest_enemy_distance = nearest_enemy.dist_from_player
	else:
		nearest_enemy_distance = INF
		
	velocity = Input.get_vector("left","right","up","down") * speed
	move_and_collide(velocity * delta)

func take_damage(amount):
	health -= amount
	print(health)

func _on_self_damage_body_entered(body: Node2D) -> void:
	take_damage(body.damage) # Replace with function body.


func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled",true)
	%Collision.set_deferred("disabled",false)
