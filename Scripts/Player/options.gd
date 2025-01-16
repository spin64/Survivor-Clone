extends VBoxContainer

@export var weapons : HBoxContainer
var OptionSlot = preload("res://Scenes/option_slot.tscn")

@export var panel : NinePatchRect

func _ready():
	hide()
	panel.hide()

func close_option():
	hide()
	panel.hide()
	get_tree().paused = false
	
func get_avalible_weapons():
	var weapon_resource = []
	for weapon in weapons.get_children():
		if weapon.weapon != null:
			weapon_resource.append(weapon.weapon)
	return weapon_resource

func show_option():
	var weapons_avalible = get_avalible_weapons()
	if weapons_avalible.size() == 0:
		return
	
	for slot in get_children():
		slot.queue_free()
		
	var option_size = 0
	for weapon in weapons_avalible:
		if weapon.is_upgradable():
			var option_slot = OptionSlot.instantiate()
			option_slot.weapon = weapon
			add_child(option_slot)
			option_size += 1
	
	if option_size == 0:
		return
		
	show()
	panel.show()
	get_tree().paused = true
