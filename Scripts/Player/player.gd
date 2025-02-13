extends CharacterBody2D

var movement_speed : float = 150
var recovery : float = 0
var armor : float = 0
var might : float = 1.0
var area : float = 0
var growth : float = 1

var health : float = 100 :
	set (value):
		health = max(value, 0)
		%HealthBar.value = value
		
var max_health : float = 100 :
	set(value):
		max_health = value
		%HealthBar.max_value = value
		
var magnet : float = 0:
	set(value):
		magnet = value
		%Magnet.shape.radius = 50 + value

var nearest_enemy : CharacterBody2D
var nearest_enemy_distance : float = 150 + area

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
		nearest_enemy_distance = 150 + area
		nearest_enemy = null
		
	velocity = Input.get_vector("left","right","up","down") * movement_speed
	
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	elif velocity.x < 0:
		$Sprite2D.flip_h = false
	
	move_and_collide(velocity * delta)
	check_XP()
	health += recovery * delta

func take_damage(amount):
	health -= max(amount - armor, 0)
	#print(health)

func _on_self_damage_body_entered(body: Node2D) -> void:
	take_damage(body.damage)

func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled",true)
	%Collision.set_deferred("disabled",false)

func gain_XP(amount):
	XP += amount * growth
	total_XP += amount * growth
	
func check_XP():
	if XP >= %XP.max_value:
		XP = 0
		level += 1

func _on_magnet_area_entered(area: Area2D) -> void:
	if area.has_method("follow"):
		area.follow(self)
		
func open_chest():
	$UI/Chest.open()
