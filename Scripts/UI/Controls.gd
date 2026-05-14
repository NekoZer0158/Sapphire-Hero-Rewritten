class_name Controls
extends Control

@export var active_color : Color
@export var parent_node : Control
@export var controls_options : Container
@export var keyboard_container : Container
@export var keyboard_azerty_container : Container
@export var gamepad_xbox_container : Container
@export var gamepad_playstation_container : Container
@export var gamepad_m30_container : Container
@export var mobile_parent_node : Control
@export var settings_menu : Settings

@onready var keyboard = $Controls_options/Keyboard
@onready var mobile_node: Control = $Mobile
@onready var keyboard_type_label: Label = $Controls_options/Keyboard_type
@onready var gamepad_xbox_or_else_label: Label = $Controls_options/Gamepad_xbox_or_else

enum {KEYBOARD_AZERTY=1,GAMEPAD_XBOX=2,GAMEPAD_PLAYSTATION=3,GAMEPAD_M30=4}
enum {KEYBOARD,KEYBOARD_TYPE,XBOX_GAMEPAD_OR_ELSE,BACK}

var controls_options_labels : Array[Node]
var cur_option : int = 0
var cur_controls_option : int = 0:
	set(value):
		cur_controls_option = clamp(value,0,4)

signal hide_controls()

func _ready():
	if !is_instance_valid(parent_node):
		push_error("No parent_node")
	controls_options_labels = controls_options.get_children()
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
	_set_gamepad_xbox_or_else_text()
	_set_keyboard_type_text()

func set_keyboard_text() -> void:
	match cur_controls_option:
		KEYBOARD:
			gamepad_xbox_container.hide()
			gamepad_playstation_container.hide()
			keyboard_azerty_container.hide()
			keyboard_container.show()
			keyboard.text = TranslationServer.translate("Keyboard")+">"
		KEYBOARD_AZERTY:
			keyboard_azerty_container.show()
			gamepad_playstation_container.hide()
			gamepad_xbox_container.hide()
			keyboard_container.hide()
			keyboard.text = "<"+TranslationServer.translate("Keyboard_azerty")+">"
		GAMEPAD_XBOX:
			keyboard_container.hide()
			gamepad_playstation_container.hide()
			gamepad_xbox_container.show()
			keyboard_azerty_container.hide()
			keyboard.text = "<"+TranslationServer.translate("Gamepad_xbox")+">"
		GAMEPAD_PLAYSTATION:
			keyboard_container.hide()
			gamepad_xbox_container.hide()
			keyboard_azerty_container.hide()
			gamepad_playstation_container.show()
			gamepad_m30_container.hide()
			keyboard.text = "<"+TranslationServer.translate("Gamepad_playstation")+">"
		GAMEPAD_M30:
			keyboard_container.hide()
			gamepad_xbox_container.hide()
			keyboard_azerty_container.hide()
			gamepad_playstation_container.hide()
			gamepad_m30_container.show()
			keyboard.text = "<"+TranslationServer.translate("Gamepad_m30")

func _input(event:InputEvent) -> void:
	if visible:
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
		match cur_option:
			KEYBOARD:
				if event.is_action_pressed(&"Menu_Left"):
					cur_controls_option -= 1
				elif event.is_action_pressed(&"Menu_Right"):
					cur_controls_option += 1
				set_keyboard_text()
			KEYBOARD_TYPE:
				if event.is_action_pressed(&"Menu_Left"):
					GlobalSapphire.keyboard_type -= 1
					_set_keyboard_type_text()
				elif event.is_action_pressed(&"Menu_Right"):
					GlobalSapphire.keyboard_type += 1
					_set_keyboard_type_text()
				settings_menu.save_global_save_data()
			XBOX_GAMEPAD_OR_ELSE:
				if event.is_action_pressed(&"Menu_Left"):
					GlobalSapphire.xbox_gamepad_type -= 1
					_set_gamepad_xbox_or_else_text()
				elif event.is_action_pressed(&"Menu_Right"):
					GlobalSapphire.xbox_gamepad_type += 1
					_set_gamepad_xbox_or_else_text()
				settings_menu.save_global_save_data()

func _set_keyboard_type_text() -> void:
	match GlobalSapphire.keyboard_type:
		GlobalEnum.KeyboardTypes.QWERTY:
			keyboard_type_label.text = TranslationServer.translate("Keyboard_type")+": QWERTY>"
		GlobalEnum.KeyboardTypes.AZERTY:
			keyboard_type_label.text = TranslationServer.translate("Keyboard_type")+": <AZERTY"

func _set_gamepad_xbox_or_else_text() -> void:
	match GlobalSapphire.xbox_gamepad_type:
		GlobalEnum.XboxGamepadTypes.XBOX:
			gamepad_xbox_or_else_label.text = TranslationServer.translate("Gamepad_xbox_or_else")+": Xbox>"
		GlobalEnum.XboxGamepadTypes.M30:
			gamepad_xbox_or_else_label.text = TranslationServer.translate("Gamepad_xbox_or_else")+": <M30"

func activate_option(current_option:int) -> void:
	match current_option:
		BACK:
			await get_tree().create_timer(0.06).timeout
			hide()
			if OS.has_feature("mobile"):
				mobile_parent_node.show()
			parent_node.show()
			hide_controls.emit()

func set_color_for_cur_option(current_option:int) -> void:
	for i in controls_options_labels:
		i.self_modulate = Color.WHITE
	controls_options_labels[current_option].self_modulate = active_color
