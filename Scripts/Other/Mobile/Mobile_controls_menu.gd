extends Control

@export var parent_node : Controls

enum {KEYBOARD,BACK}

func _on_back_pressed() -> void:
	parent_node.activate_option(BACK)
