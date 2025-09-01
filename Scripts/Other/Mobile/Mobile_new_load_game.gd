extends Control

@export var new_load_game_menu : New_load_game

@onready var button_main_universe: Button = $Dimension/Button_main_universe
@onready var button_alternative_universe_1: Button = $Dimension/Button_alternative_universe1
@onready var dimension: Control = $Dimension
@onready var legend_description: Label = $Dimension/Description
@onready var touch_screen_button_right: TouchScreenButton = $TouchScreenButtonRight
@onready var touch_screen_button_left: TouchScreenButton = $TouchScreenButtonLeft

var save_slot_number : int = -1

enum {SLOT_1,SLOT_2,SLOT_3,BACK}
enum {NEW_GAME,LOAD_GAME}

func set_default() -> void:
	legend_description.text = TranslationServer.translate("legend_description_1")+"\n"+TranslationServer.translate("legend_description_2")
	touch_screen_button_left.hide()
	touch_screen_button_right.show()

func connect_save_slots() -> void:
	if OS.has_feature("mobile"):
		for i in range(0,new_load_game_menu.save_slots.size()):
			new_load_game_menu.save_slots[i].get_node("Mobile/Button").show()
			new_load_game_menu.save_slots[i].get_node("Mobile/Button").pressed.connect(_pressed_saveslot_button.bind(i))

func _pressed_saveslot_button(number:int) -> void:
	if !dimension.visible:
		if new_load_game_menu.state == LOAD_GAME:
			new_load_game_menu.activate_option(number)
		else:
			new_load_game_menu.save_slots[number].select_border(new_load_game_menu.active_color)
			save_slot_number = number
			dimension.show()

func _pressed_dimension_button(dimension_number:int) -> void:
	new_load_game_menu.save_slots[save_slot_number].cur_dimension = dimension_number
	new_load_game_menu.activate_option(save_slot_number)

func _on_back_pressed() -> void:
	if GlobalSapphire.mobile_version:
		if dimension.visible:
			dimension.hide()
			new_load_game_menu.save_slots[save_slot_number].select_border(Color.WHITE)
		else:
			new_load_game_menu.activate_option(BACK,true)
			new_load_game_menu.hide()
			new_load_game_menu.mobile_main_node.show()

func _on_touch_screen_button_right_pressed() -> void:
	new_load_game_menu.next_slots_page()
	touch_screen_button_left.show()
	if new_load_game_menu.cur_slots_page == new_load_game_menu.amount_of_pages-1:
		touch_screen_button_right.hide()
	else:
		touch_screen_button_right.show()

func _on_touch_screen_button_left_pressed() -> void:
	new_load_game_menu.previous_slots_page()
	touch_screen_button_right.show()
	if new_load_game_menu.cur_slots_page == 0:
		touch_screen_button_left.hide()
	else:
		touch_screen_button_left.show()
