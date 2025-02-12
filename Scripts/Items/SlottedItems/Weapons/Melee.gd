extends Weapon
class_name Melee

func shoot(source, scene_tree):
	var projectile = projectile_node.instantiate()
	
	projectile.source = source
	projectile.damage = damage
	projectile.speed = 0
	
	var projectile2 = null

	var projectile_offset: float = 75
	var rectangle_width: float = 100
	var rectangle_height: float = 25

	var facing_direction = source.transform.x.normalized() * -1
	
	if source.get_node("Sprite2D").flip_h:
		facing_direction = -facing_direction
		projectile.get_node("Sprite2D").rotation_degrees += 180
	
	var spawn_position = source.global_position + facing_direction * projectile_offset
	projectile.global_position = spawn_position
	
	if projectile.has_node("CollisionShape2D"):
		var collision_shape = projectile.get_node("CollisionShape2D")
		collision_shape.shape.extents = Vector2(rectangle_width / 2, rectangle_height / 2)

	projectile.direction = Vector2.ZERO
	scene_tree.current_scene.add_child(projectile)

	if numOfProjectiles == 2:
		projectile2 = projectile_node.instantiate()
		projectile2.source = source
		projectile2.damage = damage
		projectile2.speed = 0
		projectile2.global_position = source.global_position - facing_direction * projectile_offset 

		if projectile2.has_node("CollisionShape2D"):
			var collision_shape2 = projectile2.get_node("CollisionShape2D")
			collision_shape2.shape.extents = Vector2(rectangle_width / 2, rectangle_height / 2)
		
		projectile2.get_node("Sprite2D").rotation_degrees = projectile.get_node("Sprite2D").rotation_degrees + 180

		projectile2.direction = Vector2.ZERO
		scene_tree.current_scene.add_child(projectile2)

	await scene_tree.create_timer(0.1).timeout
	
	if projectile.is_inside_tree():
		projectile.queue_free()
	
	if projectile2 != null and projectile2.is_inside_tree():
		projectile2.queue_free()

func activate(source, target, scene_tree):
	shoot(source, scene_tree)
	
func upgrade_item():
	if not is_upgradable():
		return
	
	var upgrade = upgrades[level - 1]
	damage += upgrade.damage
	cooldown += upgrade.cooldown
	numOfProjectiles += upgrade.numOfProjectiles
	
	level += 1
