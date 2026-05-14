extends Control

@export var parent_node : Controls

enum {KEYBOARD,KEYBOARD_TYPE,XBOX_GAMEPAD_OR_ELSE,BACK}

func _on_back_pressed() -> void:
	parent_node.activate_option(BACK)
