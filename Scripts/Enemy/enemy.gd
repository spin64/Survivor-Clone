extends CharacterBody2D

@export var player_reference : CharacterBody2D
var direction : Vector2
var speed : float = 75
var damage : float
var knockback : Vector2
var dist_from_player : float

var drop = preload("res://Scenes/pickups.tscn")

var health : float:
	set(value):
		health = value
		if health <= 0:
			drop_item()
			queue_free()

var elite : bool = false:
	set(value):
		elite = value
		if value:
			$Sprite2D.material = load("res://Shaders/Rainbow.tres")
			scale = Vector2(1.5,1.5)

var type : Enemy:
	set(value):
		type = value
		$Sprite2D.texture = value.texture
		damage = value.damage
		health = value.health


func _physics_process(delta):
	check_separation(delta)
	knockback_update(delta)

func check_separation(_delta):
	dist_from_player = (player_reference.position - self.position).length()
	
	if dist_from_player < player_reference.nearest_enemy_distance:
		player_reference.nearest_enemy = self
	
	if dist_from_player >= 500 and not elite:
		queue_free()

func knockback_update(delta):
	velocity = (player_reference.position - position).normalized() * speed
	
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	elif velocity.x < 0:
		$Sprite2D.flip_h = false
	
	knockback = knockback.move_toward(Vector2.ZERO, 1)
	velocity += knockback
	var collider = move_and_collide(velocity * delta)
	if collider:
		collider.get_collider().knockback = (collider.get_collider().global_position - global_position).normalized() * 50

func take_damage(amount):
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(3, 0.25, 0.25), 0.2)
	tween.chain().tween_property($Sprite2D, "modulate", Color(1, 1, 1), 0.2)
	tween.bind_node(self)
	
	health -= amount

func drop_item():
	if type.drops.size() == 0:
		return
	
	var item = type.drops.pick_random()
	var item_to_drop = drop.instantiate()
	
	item_to_drop.type = item
	item_to_drop.position = position
	item_to_drop.player_reference = player_reference
	
	print(item_to_drop.player_reference)
	
	get_tree().current_scene.call_deferred("add_child", item_to_drop)
