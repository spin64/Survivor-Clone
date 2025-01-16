extends CharacterBody2D

var speed : float = 150

var nearest_enemy : CharacterBody2D
var nearest_enemy_distance : float = INF

var health : float = 100 :
	set (value):
		health = value
		%HealthBar.value = value

var level : int = 1:
	set (value):
		level = value
		%Level.text = "Lv " + str(value)
		
		if level != 1:
			%Options.show_option()
		
		if level >= 2:
			%XP.max_value *= 1.2

var XP : int = 0:
	set(value):
		XP = value
		%XP.value = value
		
var total_XP : int = 0

func _ready():
	level = 1

func _physics_process(delta: float) -> void:
	if is_instance_valid(nearest_enemy):
		nearest_enemy_distance = nearest_enemy.dist_from_player
	else:
		nearest_enemy_distance = INF
		
	velocity = Input.get_vector("left","right","up","down") * speed
	
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	elif velocity.x < 0:
		$Sprite2D.flip_h = false
	
	move_and_collide(velocity * delta)
	check_XP()

func take_damage(amount):
	health -= amount
	print(health)

func _on_self_damage_body_entered(body: Node2D) -> void:
	take_damage(body.damage)

func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled",true)
	%Collision.set_deferred("disabled",false)

func gain_XP(amount):
	XP += amount
	total_XP += amount
	
func check_XP():
	if XP >= %XP.max_value:
		XP = 0
		level += 1

func _on_magnet_area_entered(area: Area2D) -> void:
	if area.has_method("follow"):
		area.follow(self)
