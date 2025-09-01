extends Control

@export var credits_node : Credits
@onready var page: Button = $Container/Page

enum {PAGE,LICENSE,BACK}

func _on_license_pressed() -> void:
	credits_node.activate_option(LICENSE)

func _on_back_pressed() -> void:
	page.text = ">"
	credits_node.activate_option(BACK)

func _on_page_pressed() -> void:
	if page.text == ">":
		credits_node.change_page(2)
		page.text = "<"
	else:
		credits_node.change_page(1)
		page.text = ">"
