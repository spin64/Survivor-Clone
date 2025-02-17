extends VBoxContainer
 
@export var weapons : HBoxContainer
@export var passive_items : HBoxContainer
var OptionSlot = preload("res://scenes/Player/option_slot.tscn")
 
@export var panel : NinePatchRect
 
func _ready():
	hide()
	panel.hide()
 
func close_option():
	hide()
	panel.hide()
	get_tree().paused = false
 
func get_available_resource_in(items)-> Array[Item]:
	var resources : Array[Item] = []
	for item in items.get_children():
		if item.item != null:
			resources.append(item.item)
	return resources
 
func add_option(item) -> int:
	if item.is_upgradable():
		var option_slot = OptionSlot.instantiate()
		#print(item.title)
		option_slot.item = item
		add_child(option_slot)
		return 1
	return 0
 
func show_option():
	var weapons_available = get_available_resource_in(weapons)
	var passive_item_available = get_available_resource_in(passive_items)
	if weapons_available.size() == 0 and passive_item_available.size() == 0:
		return
 
	for slot in get_children():
		slot.queue_free()
 
	var option_size = 0
	for weapon in weapons_available:
		option_size += add_option(weapon)

	for passive_item in passive_item_available:
		option_size += add_option(passive_item)
 
	if option_size == 0:
		return
 
	show()
	panel.show()
	get_tree().paused = true
	
func get_avalible_upgrades() -> Array[Item]:
	var upgrades : Array[Item] = []
	
	for weapon in get_available_resource_in(weapons):
		if weapon.is_upgradable():
			upgrades.append(weapon)
	
	for passive_item in get_available_resource_in(passive_items):
		if passive_item.is_upgradable():
			upgrades.append(passive_item)
	
	return upgrades
