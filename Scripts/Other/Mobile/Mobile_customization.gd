extends Control

@export_color_no_alpha var color : Color
@export var customization_node : Customization_UI

@onready var tsb_left: TouchScreenButton = $TSB_left
@onready var tsb_right: TouchScreenButton = $TSB_right

enum {CUR_CUSTOMIZATION,TAB_CONTAINER,BACK}

func connect_everything(nodes_with_buttons) -> void:
	for i in range(0,nodes_with_buttons.size()):
		for j in nodes_with_buttons[i]:
			j.button_mobile.pressed.connect(_customization_button_pressed.bind(j,i))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Customization_left"):
		customization_node.menu_left_pressed(-1)
		if customization_node.cur_something_array_index == 0:
			tsb_left.hide()
		else:
			tsb_right.show()
	elif event.is_action_pressed(&"Customization_right"):
		customization_node.menu_right_pressed(1)
		if customization_node.cur_something_array_index == customization_node.containers_names.size()-1:
			tsb_right.hide()
		else:
			tsb_left.show()

func _customization_button_pressed(customization_slot:Customization_select,index:int) -> void:
	customization_node.unselect_a_background()
	customization_node.hbox_container_children[customization_node.cur_something_array_index][customization_node.cur_something[customization_node.cur_something_array_index]].unselect()
	customization_slot.background.modulate = color*0.65
	customization_node.cur_something[index] = customization_node.hbox_container_children[customization_node.cur_something_array_index].find(customization_slot)
	customization_node.custom_text.text = customization_slot.text[0]
	if customization_slot.unlocked:
		customization_node.custom_text.text = customization_slot.text[0]
	else:
		customization_node.custom_text.text = customization_slot.how_to_unlock_text
	customization_slot.select(color)
	customization_node.save_customization_data()

func _on_back_pressed() -> void:
	tsb_left.hide()
	customization_node.activate_option(BACK)
