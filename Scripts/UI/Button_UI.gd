class_name Button_UI
extends Node2D

@export var cur_button : String = ""
@export_color_no_alpha var label_shadow_color : Color = Color("4562d6")

@onready var label = $Label

func _ready():
	if cur_button.length() > 1:
		cur_button = cur_button[0]
		push_warning("There are should be only one letter")
	cur_button.to_upper()
	label["theme_override_colors/font_shadow_color"] = label_shadow_color
	if OS.has_feature("mobile"):
		$Sprite2D.hide()
		label.hide()
	set_button_text()

func set_button_text() -> void:
	label.text = cur_button

func change_label_shadow_color(new_color:Color) -> void:
	label_shadow_color = new_color
	label["theme_override_colors/font_shadow_color"] = label_shadow_color
