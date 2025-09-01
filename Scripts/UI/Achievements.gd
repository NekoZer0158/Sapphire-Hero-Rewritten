class_name Achievements
extends Control

@export_color_no_alpha var active_color : Color
@export var parent_node : Control
@export var mobile_parent_node : Control
@export var options : Array[Node]

@onready var achievement_text: Label = $Achievement_text
@onready var mobile_node: Control = $Mobile

var no_left_move_if_this_option : Array[int] = [3,6]
var no_right_move_if_this_option : Array[int] = [2,5,8]

var cur_option : int = 9:
	set(value):
		if value > 9:
			cur_option = 9
		elif value < 0:
			cur_option = 0
		else:
			cur_option = value

signal unlocked_all_achievements()

func _ready() -> void:
	$VBoxContainer/Back.self_modulate = active_color
	if OS.has_feature("mobile"):
		$VBoxContainer.hide()
		mobile_node.show()
	else:
		mobile_node.queue_free()
	if !has_achievements_file():
		create_achievements_file()
	else:
		load_achievements()
	if !GlobalSapphire.game_was_completed:
		$Achievements/Achievement9/Sprite2D.texture = load("res://Sprites/UI/Achievements/Black_baron_achievement_hidden.png")

func _input(event: InputEvent) -> void:
	if visible and !GlobalSapphire.mobile_version:
		if event.is_action_pressed(&"Back"):
			back_button_pressed()
		if cur_option < 9:
			if event.is_action_pressed(&"Menu_Left") and not cur_option in no_left_move_if_this_option:
				change_option(-1)
			elif event.is_action_pressed(&"Menu_Right") and not cur_option in no_right_move_if_this_option:
				change_option(1)
			elif event.is_action_pressed(&"Menu_Down"):
				change_option(3)
			elif event.is_action_pressed(&"Menu_Up") and cur_option > 2:
				change_option(-3)
		elif event.is_action_pressed(&"Menu_Activate"):
			back_button_pressed()
		elif event.is_action_pressed(&"Menu_Up"):
			change_option(-2)

func back_button_pressed() -> void:
	await get_tree().create_timer(0.06).timeout
	hide()
	if OS.has_feature("mobile"):
		mobile_parent_node.show()
	parent_node.show()

func change_option(number:int) -> void:
	var previous_option = options[cur_option]
	var next_option
	if previous_option is Label:
		previous_option.self_modulate = Color.WHITE
	elif previous_option is Achievement:
		previous_option.deactivate()
		achievement_text.text = ""
	cur_option += number
	next_option = options[cur_option]
	if next_option is Label:
		next_option.self_modulate = active_color
	elif next_option is Achievement:
		next_option.activate()
		achievement_text.text = next_option.Desc

func has_achievements_file() -> bool:
	var achievements_path : String = "user://Achievements.json"
	if FileAccess.file_exists(achievements_path):
		return true
	return false

func create_achievements_file() -> void:
	var achievements_path : String = "user://Achievements.json"
	var achievements_file := FileAccess.open(achievements_path,FileAccess.WRITE)
	var achievements_data = Achievements_data.new()
	var achievements_data_json := {
		"unlocked_achievements":achievements_data.unlocked_achievements.duplicate(true)
	}
	var json_string := JSON.stringify(achievements_data_json)
	achievements_file.store_line(json_string)
	achievements_file.close()

func load_achievements() -> void:
	var unlocked_achievements : int = 0
	var achievements_path : String = "user://Achievements.json"
	var achievements_file := FileAccess.open(achievements_path,FileAccess.READ)
	var json_string : String
	var json_data
	json_string = achievements_file.get_line()
	achievements_file.close()
	json_data = JSON.parse_string(json_string)
	GlobalSapphire.achievements_data = Achievements_data.new()
	GlobalSapphire.achievements_data.unlocked_achievements = json_data.unlocked_achievements.duplicate(true)
	for i in options:
		if i is Achievement:
			if i.Name in GlobalSapphire.achievements_data.unlocked_achievements:
				unlocked_achievements += 1
				i.unlock_achievement()
	if unlocked_achievements == 9:
		emit_signal("unlocked_all_achievements")
