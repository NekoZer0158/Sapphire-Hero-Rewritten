class_name Credits
extends Control

@export var active_color : Color
@export var parent_node : Control
@export var credits_text : Array[RichTextLabel]
@export var mobile_parent_node : Control

@onready var credits_options = $Credits_options
@onready var page_label: Label = $Credits_options/Page

var credits_option : int = 0
var credits_options_labels : Array[Node]
var default_text : Array = []

enum {PAGE,LICENSE,BACK}

const MAX_AMOUNT_OF_PAGES = 2
const TEXT_FOR_PAGES : Array[Array] = [["Font_creator","Creator of the most things","Tools list"],["Music_left","Music creator","Music_right"]]

func _ready() -> void:
	if OS.has_feature("mobile"):
		credits_options.hide()
		$Mobile.show()

func set_default() -> void:
	credits_options_labels = credits_options.get_children()
	credits_option = 0
	change_page(1)
	set_color_for_cur_option(credits_option)

func translate_credits(cur_page:int) -> void:
	for i in range(0,credits_text.size()):
		credits_text[i].text = TranslationServer.translate(TEXT_FOR_PAGES[cur_page-1][i]).c_unescape()

func change_page(new_page : int) -> void:
	if new_page == 1:
		page_label.text = str(new_page)+">"
	elif new_page > 1 and new_page < MAX_AMOUNT_OF_PAGES:
		page_label.text = "<"+str(new_page)+">"
	else:
		page_label.text = "<"+str(new_page)
	for i in range(0,credits_text.size()):
		credits_text[i].text = TEXT_FOR_PAGES[new_page-1][i]
	translate_credits(new_page)

func _input(event):
	if visible:
		if event.is_action_pressed(&"Menu_Down") and credits_option < BACK:
			credits_option += 1
			set_color_for_cur_option(credits_option)
		elif event.is_action_pressed(&"Menu_Up") and credits_option > 0:
			credits_option -= 1
			set_color_for_cur_option(credits_option)
		elif credits_option == PAGE:
			if event.is_action_pressed(&"Menu_Left"):
				change_page(1)
			elif event.is_action_pressed(&"Menu_Right"):
				change_page(2)
			elif event.is_action_pressed(&"Pause"):
				activate_option(BACK)
		elif event.is_action_pressed(&"Menu_Activate"):
			activate_option(credits_option)
		elif event.is_action_pressed(&"Back"):
			activate_option(BACK)

func activate_option(cur_option:int) -> void:
	match cur_option:
		LICENSE:
			OS.shell_open("https://godotengine.org/license")
		BACK:
			await get_tree().create_timer(0.06).timeout
			hide()
			if GlobalSapphire.mobile_version:
				mobile_parent_node.show()
			parent_node.show()

func set_color_for_cur_option(cur_option:int) -> void:
	for i in credits_options_labels:
		i.self_modulate = Color.WHITE
	if credits_options_labels.size() > 0:
		credits_options_labels[cur_option].self_modulate = active_color
