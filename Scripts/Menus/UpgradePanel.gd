extends Panel

@export var skill : Skill
var level : int = 0
var pips : Array = []
var total_stat : Stats

func _ready() -> void:
	if skill:
		%Icon.texture_normal = skill.texture
	else:
		return
		
	pips = %Icon.get_children()
	
	if SaveData.upgrades.has(skill.name):
		total_stat = Stats.new()
		level = SaveData.upgrades[skill.name]

		for i in range(level):
			pips[i].modulate = Color(0.333, 1, 0.333)
			add_stats(skill.stats[i])
			Persistance.bonus_stats = total_stat

func _on_button_pressed() -> void:
	if level >= 0 and level < pips.size() and skill.cost <= SaveData.gold:
		pips[level].modulate = Color(0.333, 1, 0.333)
		level += 1
		
		SaveData.upgrades[skill.name] = level
		SaveData.gold -= skill.cost
		SaveData.set_and_save()

func add_stats(stat):
	total_stat.max_health += stat.max_health 
	total_stat.recovery += stat.recovery
	total_stat.armor += stat.armor
	total_stat.movement_speed += stat.movement_speed
	total_stat.might += stat.might
	total_stat.area += stat.area
	total_stat.magnet += stat.magnet
	total_stat.growth += stat.growth
	
