extends Control

func _ready() -> void:
	menu()

func _on_upgrade_pressed() -> void:
	upgrade_menu()
	
func _on_back_pressed() -> void:
	menu()

func menu():
	$Menu.show()
	$Upgrades.hide()
	$Gold.hide()
	$Back.hide()

func upgrade_menu():
	$Menu.hide()
	$Upgrades.show()
	$Gold.show()
	$Back.show()
