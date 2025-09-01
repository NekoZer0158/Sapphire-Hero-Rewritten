class_name Controls
extends Control

@export var active_color : Color
@export var parent_node : Control
@export var mobile_parent_node : Control
@export var controls_options : Container
@export var keyboard_container : Container
@export var gamepad_xbox_container : Container
@export var gamepad_playstation_container : Container

@onready var keyboard = $Controls_options/Keyboard
@onready var mobile_node: Control = $Mobile

var controls_options_labels : Array[Node]
var cur_option : int = 0
var cur_controls_option : int = 0:
	set(value):
		cur_controls_option = clamp(value,0,2)

enum {GAMEPAD_XBOX=1,GAMEPAD_PLAYSTATION=2}
enum {KEYBOARD,BACK}

func _ready():
	if !is_instance_valid(parent_node):
		push_error("No parent_node")
	controls_options_labels = controls_options.get_children()
	set_keyboard_text()
	set_color_for_cur_option(0)
	if !OS.has_feature("mobile"):
		mobile_node.queue_free()
	else:
		keyboard_container.hide()
		gamepad_xbox_container.hide()
		controls_options.hide()
		mobile_node.show()

func set_default() -> void:
	cur_option = 0
	cur_controls_option = 0
	set_keyboard_text()
	set_color_for_cur_option(cur_option)
	if GlobalSapphire.mobile_version:
		keyboard_container.hide()
		gamepad_xbox_container.hide()
		controls_options.hide()
		mobile_node.show()

func set_keyboard_text() -> void:
	match cur_controls_option:
		KEYBOARD:
			gamepad_xbox_container.hide()
			gamepad_playstation_container.hide()
			keyboard_container.show()
			keyboard.text = TranslationServer.translate("Keyboard")+">"
		GAMEPAD_XBOX:
			keyboard_container.hide()
			gamepad_playstation_container.hide()
			gamepad_xbox_container.show()
			keyboard.text = "<"+TranslationServer.translate("Gamepad_xbox")+">"
		GAMEPAD_PLAYSTATION:
			keyboard_container.hide()
			gamepad_xbox_container.hide()
			gamepad_playstation_container.show()
			keyboard.text = "<"+TranslationServer.translate("Gamepad_playstation")

func _input(event):
	if visible and !GlobalSapphire.mobile_version:
		if event.is_action_pressed(&"Menu_Activate"):
			activate_option(cur_option)
		elif event.is_action_pressed(&"Menu_Down") and cur_option < BACK:
			cur_option += 1
			set_color_for_cur_option(cur_option)
		elif event.is_action_pressed(&"Menu_Up") and cur_option > KEYBOARD:
			cur_option -= 1
			set_color_for_cur_option(cur_option)
		elif event.is_action_pressed(&"Back"):
			activate_option(BACK)
		if cur_option == KEYBOARD:
			if event.is_action_pressed(&"Menu_Left"):
				cur_controls_option -= 1
			elif event.is_action_pressed(&"Menu_Right"):
				cur_controls_option += 1
			set_keyboard_text()

func activate_option(current_option:int) -> void:
	match current_option:
		BACK:
			await get_tree().create_timer(0.06).timeout
			hide()
			if GlobalSapphire.mobile_version:
				mobile_parent_node.show()
			parent_node.show()

func set_color_for_cur_option(current_option:int) -> void:
	for i in controls_options_labels:
		i.self_modulate = Color.WHITE
	controls_options_labels[current_option].self_modulate = active_color
