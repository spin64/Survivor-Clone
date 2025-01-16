extends PanelContainer

@export var weapon : Weapon:
	set(value):
		weapon = value
		$TextureRect.texture = value.texture
		$Cooldown.wait_time = value.cooldown
		
func _physics_process(delta: float) -> void:
	if weapon != null and weapon.has_method("update"):
		weapon.update(delta)

func _on_cooldown_timeout() -> void:
	if weapon:
		$Cooldown.wait_time = weapon.cooldown
		weapon.activate(owner, owner.nearest_enemy, get_tree())
