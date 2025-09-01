class_name Boss_selection_slot
extends Control

@export_color_no_alpha var color : Color
@export var boss_body : PackedScene
@export var level_path : String
@export var level_preview : PackedScene
@export var level_preview_pos : Marker2D
@export var boss_name : String
@export var hide_boss_look : bool = false
@export var path_for_other_dimensions : Dictionary[int,String]
@export var other_boss_name : Dictionary[int,String]
@export var other_boss_body : Dictionary[int,PackedScene]

@onready var body_position : Marker2D = $Body_position
@onready var sprite_2d = $Sprite2D
@onready var background = $Background
@onready var hide_boss_look_sprite = $Hide_boss_look
@onready var button_mobile: Button = $Button_mobile

var dimension : int = 1:
	set(value):
		if value != 1:
			if value in path_for_other_dimensions.keys():
				dimension = value
				level_path = path_for_other_dimensions[value]
			if value in other_boss_body.keys():
				dimension = value
				if check_body(other_boss_body[value]):
					body_position.get_child(0).queue_free()
					var new_boss_body := other_boss_body[value].instantiate()
					new_boss_body.process_mode = Node.PROCESS_MODE_DISABLED
					body_position.add_child(new_boss_body)
				else:
					push_error("Problem with new boss body")
			if value in other_boss_name.keys():
				dimension = value
				boss_name = other_boss_name[value]
var cur_level_preview : Level_preview

func _ready():
	if check_body(boss_body) and check_level_preview():
		var spawned_body = boss_body.instantiate()
		spawned_body.process_mode = Node.PROCESS_MODE_DISABLED
		body_position.add_child(spawned_body)
		background.modulate = color*0.35
		if hide_boss_look:
			hide_boss_look_sprite.show()
			button_mobile.hide()
		elif GlobalSapphire.mobile_version:
			button_mobile.show()
			button_mobile.focus_mode=Control.FOCUS_NONE
		else:
			button_mobile.queue_free()
	else:
		push_error("Wrong boss body or level_preview")

func unselect_background() -> void:
	background.modulate = color*0.35

func select_background() -> void:
	background.modulate = color*0.65

func show_boss_look() -> void:
	hide_boss_look_sprite.queue_free()
	button_mobile.show()

func set_dimension_color(dimension_colors:Dictionary[int,Color]) -> void:
	$Dimension.self_modulate = dimension_colors[dimension]

func check_level_preview() -> bool:
	if level_preview != null:
		var check_this_level_preview = level_preview.instantiate()
		if check_this_level_preview is Level_preview:
			return true
	return false

func check_body(cur_boss_body) -> bool:
	if cur_boss_body != null:
		var check_this_body = cur_boss_body.instantiate()
		if check_this_body is Moving_body_extended:
			return true
	return false

func activate_level() -> void:
	var spawn_this_level = load(level_path).instantiate()
	get_parent().get_parent().get_parent().call_deferred("add_child",spawn_this_level)

func hide_level() -> void:
	if is_instance_valid(cur_level_preview):
		cur_level_preview.queue_free()
		cur_level_preview.hide()

func select_level() -> void:
	cur_level_preview = level_preview.instantiate()
	get_parent().get_parent().call_deferred("add_child",cur_level_preview)
	cur_level_preview.global_position = level_preview_pos.global_position/4
