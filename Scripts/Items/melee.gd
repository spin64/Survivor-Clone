extends Weapon
class_name Melee

func shoot(source, scene_tree):
	var projectile = projectile_node.instantiate()

	var projectile_offset: float = 50
	var rectangle_width: float = 100
	var rectangle_height: float = 25

	var facing_direction = source.transform.x.normalized() * -1
	if source.get_node("Sprite2D").flip_h:
		facing_direction = -facing_direction
	
	var spawn_position = source.global_position + facing_direction * projectile_offset
	projectile.global_position = spawn_position
	
	if projectile.has_node("CollisionShape2D"):
		var collision_shape = projectile.get_node("CollisionShape2D")
		collision_shape.shape.extents = Vector2(rectangle_width / 2, rectangle_height / 2)

	if projectile.has_node("Sprite2D"):
		var sprite = projectile.get_node("Sprite2D")
		sprite.scale = Vector2(rectangle_width / sprite.texture.get_size().x, rectangle_height / sprite.texture.get_size().y)

	projectile.rotation = 0
	projectile.damage = damage
	projectile.speed = 0
	projectile.direction = Vector2.ZERO

	scene_tree.current_scene.add_child(projectile)

	await scene_tree.create_timer(0.1).timeout
	
	if projectile.is_inside_tree():
		projectile.queue_free()

func activate(source, target, scene_tree):
	shoot(source, scene_tree)
