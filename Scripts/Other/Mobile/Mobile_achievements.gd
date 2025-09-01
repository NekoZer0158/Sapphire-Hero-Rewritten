extends Control

@export var parent_node : Achievements

func _ready() -> void:
	if OS.has_feature("mobile"):
		for i in range(0,parent_node.options.size()):
			if parent_node.options[i] is Achievement:
				parent_node.options[i].button_mobile.pressed.connect(_achievement_pressed.bind(parent_node.options[i],i))

func _achievement_pressed(achievement:Achievement,_index:int) -> void:
	if parent_node.cur_option != 9:
		parent_node.options[parent_node.cur_option].deactivate()
	achievement.activate()
	parent_node.achievement_text.text = achievement.Desc
	parent_node.cur_option = parent_node.options.find(achievement)

func _on_back_pressed() -> void:
	parent_node.back_button_pressed()
