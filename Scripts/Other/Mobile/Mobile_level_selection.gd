extends Node2D

@export var level_selection : Level_selection

func connect_levels() -> void:
	if GlobalSapphire.mobile_version:
		for i in range(0,level_selection.levels.size()):
			level_selection.levels[i].button_mobile.pressed.connect(choose_this_level.bind(i))

func choose_this_level(cur_level_number:int) -> void:
	level_selection.unselect_cur_level()
	level_selection.cur_level = cur_level_number
	level_selection.select_cur_level()

func _on_back_pressed() -> void:
	level_selection.back_to_main_menu()

func _on_play_pressed() -> void:
	level_selection.activate_level()
