extends VBoxContainer

@export var weapons : HBoxContainer
@export var passive_items : HBoxContainer
@export var particles : GPUParticles2D
@export var panel : NinePatchRect

const OptionSlot = preload("res://Scenes/Player/option_slot.tscn")
const weapon_path : String = "res://Resources/Weapon/"
const passive_item_path : String = "res://Resources/Passives/"

var every_item
var every_weapon
var every_passive

func _ready():
	hide()
	panel.hide()
	get_all_items()
	
	var startingWeapon = get_equipped_item()
	startingWeapon[0].level = 1

func get_available_resource_in(items)-> Array[Item]:
	var resources : Array[Item] = []
	for item in items.get_children():
		if item.item != null:
			resources.append(item.item)
	return resources

func add_option(item) -> int:
	if item is Item and item.is_upgradable():
		var option_slot = OptionSlot.instantiate()
		option_slot.item = item
		add_child(option_slot)
		return true
	return false

func show_options():
	var weapons_available = get_available_resource_in(weapons)
	var passive_item_available = get_available_resource_in(passive_items)	
	
	if weapons_available.size() == 0 and passive_item_available.size() == 0:
		return
	
	for slot in get_children():
		slot.queue_free()
	
	var available = get_equipped_item()
	if slot_available(weapons):
		available.append_array(get_upgradable(every_weapon, get_equipped_item()))
	if slot_available(passive_items):
		available.append_array(get_upgradable(every_passive, get_equipped_item()))
	available.shuffle()
	
	var option_size = 0
	for i in range(3):
		if available.size() > 0:
			option_size += add_option(available.pop_front())
			 
	if option_size == 0:
		return
	
	show()
	panel.show()
	get_tree().paused = true

func close_option():
	hide()
	panel.hide()
	get_tree().paused = false

func dir_contents(path):
	var dir = DirAccess.open(path)
	var item_resources = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			print("Found file: " + file_name)
			var item_resource : Item = load(path + file_name)
			item_resources.append(item_resource)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		return null
	return item_resources

func get_all_items():
	var item_resources = dir_contents(weapon_path)
	every_weapon = item_resources
	
	item_resources = dir_contents(passive_item_path)
	every_passive = item_resources
	
	every_item = every_weapon.duplicate()
	every_item.append_array(every_passive)

func slot_available(items):
	for item in items.get_children():
		if item.item == null:
			return true
	return false

func get_equipped_item():
	var equipped_items = get_available_resource_in(weapons)
	equipped_items.append_array(get_available_resource_in(passive_items))
	
	return get_upgradable(equipped_items)

func add_weapon(item):
	for slot in weapons.get_children():
		if slot.item == null:
			slot.item = item
			return

func add_passive(item):
	for slot in passive_items.get_children():
		if slot.item == null:
			slot.item = item
			return

func check_item(item):
	if item in get_available_resource_in(weapons) or item in get_available_resource_in(passive_items):
		return
	else:
		if item is Weapon:
			add_weapon(item)
		elif item is PassiveItem:
			add_passive(item)

func get_upgradable(items, equippedItems = []):
	var array = []
	for item in items:
		if item.is_upgradable() and item not in equippedItems:
			array.append(item)
	return array

#for chests
func get_avalible_upgrades() -> Array[Item]:
	var upgrades : Array[Item] = []
	
	for weapon in get_available_resource_in(weapons):
		if weapon.is_upgradable():
			upgrades.append(weapon)
	
	for passive_item in get_available_resource_in(passive_items):
		if passive_item.is_upgradable():
			upgrades.append(passive_item)
	
	return upgrades
