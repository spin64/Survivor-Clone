extends Node2D

var gold = 0
var upgrades = {}

const PATH = "user://player_data.cfg"
@onready var config = ConfigFile.new()

func _ready() -> void:
	load_data()

func save_data():
	config.save(PATH)
	
func set_data():
	config.set_value("Player", "gold", gold)
	config.set_value("Player", "upgrades", upgrades)
	
func set_and_save():
	set_data()
	save_data()

func load_data():
	if config.load(PATH) != OK:
		set_and_save()
		
	upgrades = config.get_value("Player", "upgrades")		
	gold = config.get_value("Player", "gold")
