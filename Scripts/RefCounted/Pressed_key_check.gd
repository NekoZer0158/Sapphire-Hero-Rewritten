class_name Pressed_key_check
extends RefCounted

static func _check_if_this_button_pressed(button_string_name:StringName,button_string_name_m30:StringName) -> bool:
	if Input.is_action_pressed(button_string_name) and (Input.get_connected_joypads().size() == 0 or GlobalSapphire.xbox_gamepad_type == GlobalEnum.XboxGamepadTypes.XBOX or "PS" in Input.get_joy_name(0)):
		return true
	elif Input.is_action_pressed(button_string_name_m30) and GlobalSapphire.xbox_gamepad_type == GlobalEnum.XboxGamepadTypes.M30 and not "PS" in Input.get_joy_name(0):
		return true
	return false

static func _check_if_this_button_just_pressed(button_string_name:StringName,button_string_name_m30:StringName) -> bool:
	if Input.is_action_just_pressed(button_string_name) and (Input.get_connected_joypads().size() == 0 or GlobalSapphire.xbox_gamepad_type == GlobalEnum.XboxGamepadTypes.XBOX or "PS" in Input.get_joy_name(0)):
		return true
	elif Input.is_action_just_pressed(button_string_name_m30) and GlobalSapphire.xbox_gamepad_type == GlobalEnum.XboxGamepadTypes.M30 and not "PS" in Input.get_joy_name(0):
		return true
	return false
