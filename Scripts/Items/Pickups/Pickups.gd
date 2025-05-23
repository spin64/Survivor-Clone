extends Area2D

var direction : Vector2
var speed : float = 175

@export var type : Pickups
@export var player_reference : CharacterBody2D:
	set(value):
		player_reference = value
		type.player_reference = value

var can_follow : bool = false

func _ready():
	$Sprite2D.texture = type.icon

func _on_body_entered(_body):
	type.activate()
	queue_free()

func _physics_process(delta):
	#print(can_follow)
	if player_reference and can_follow:
		direction = (player_reference.position - position).normalized()
		position += direction * speed * delta

func follow(_target : CharacterBody2D):
	if type is Chest:
		return
	can_follow = true
