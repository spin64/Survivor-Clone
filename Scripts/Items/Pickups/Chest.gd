extends NinePatchRect

@onready var chest = $AnimatedSprite2D
@onready var options = %Options
@onready var rewards = $Rewards

func _ready():
	randomize()
	hide()
	$Open.show()
	$Close.hide()
	
func clear_reward():
	for slot in rewards.get_children():
		slot.texture = null
	
func open():
	clear_reward()
	chest.play("idle_chest")
	get_tree().paused = true
	show()
	$Open.show()
	$Close.hide()

func _on_open_pressed() -> void:
	chest.play("open_chest")
	await chest.animation_finished
	set_reward()
	$Open.hide()
	$Close.show()

func _on_close_pressed() -> void:
	get_tree().paused = false
	hide()
	
func set_reward():
	clear_reward()
	var chance = randf()
	if chance < 0.5:
		upgrade_item(2,3)
		print("rare")
	elif chance < 0.75:
		upgrade_item(1,4)
		print("epic")
	else:
		upgrade_item(0,5)
		print("legendary")
		
func upgrade_item(start, end):
	for index in range(start, end):
		var upgrades = options.get_avalible_upgrades()
		
		if upgrades.size() == 0:
			var gold : Gold = load("res://Resources/Pickups/Gold.tres")
			gold.player_reference = owner
			rewards.get_child(index).texture = gold.texture
			gold.upgrade_item()
		else:
			var selected_upgrade = upgrades.pick_random()
			rewards.get_child(index).texture = selected_upgrade.texture
			selected_upgrade.upgrade_item()
			
