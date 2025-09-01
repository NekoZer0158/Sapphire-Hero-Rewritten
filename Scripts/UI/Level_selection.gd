class_name Level_selection
extends Node2D

@export_color_no_alpha var active_color : Color
@export var boss_container : HBoxContainer
@export var transition_time : float = 0.7
@export var dimension_colors : Dictionary[int,Color] ## triangle color in the top right corner of the boss

@onready var black_baron := $Black_Baron
@onready var boss_name_label : Label = $Boss_name
@onready var transition := $Transition
@onready var back := $Back
@onready var boss_info_left := $Boss_info_left
@onready var boss_info_right := $Boss_info_right
@onready var mobile_node: Node2D = $Mobile
@onready var level_desc: Label = $Level_desc

var intro := preload("res://Scenes/Story/Intro.tscn")
var before_final_boss := preload("res://Scenes/Story/Before_final_boss.tscn")
var the_end := preload("res://Scenes/Story/The_end.tscn")
var first_time : bool = true ## only for the new game
var cur_level : int = 0
var can_control : bool = false
var ready_for_final_level : bool = false
var levels : Array[Node]

func _ready():
	randomize()
	GlobalSapphire.cur_checkpoint = 0
	GlobalSapphire.cur_hp_refills = 0
	GlobalSapphire.cur_ammo.clear()
	for i in get_tree().get_nodes_in_group("Projectile"):
		i.queue_free()
	if is_instance_valid(boss_container):
		randomize_levels()
		levels = boss_container.get_children()
		set_dimension_for_each_level()
		final_boss_completed_check()
		change_level(0)
	else:
		push_error("No boss_container")
	if GlobalSapphire.mobile_version:
		mobile_node.show()
		back.hide()
		mobile_node.connect_levels()
	else:
		mobile_node.queue_free()
	if !first_time:
		if GlobalSapphire.player_savedata.completed_levels["Black_Baron"] == 1 and !GlobalSapphire.player_savedata.other_data["Watched_ending"]:
			var spawn_this = the_end.instantiate()
			spawn_this.parent_node = self
			get_parent().add_child(spawn_this)
			GlobalSapphire.player_savedata.other_data["Watched_ending"] = true
			GlobalSapphire.save_data()
			GlobalSapphire.game_was_completed = 1
			save_global_save_data()
		elif !GlobalSapphire.player_savedata.other_data["Watched_cutscene_before_final_boss"] and ready_for_final_level:
			var spawn_this = before_final_boss.instantiate()
			spawn_this.parent_node = self
			get_parent().add_child(spawn_this)
			GlobalSapphire.player_savedata.other_data["Watched_cutscene_before_final_boss"] = true
			GlobalSapphire.save_data()
		else:
			use_transition()
	else:
		var spawn_this_intro = intro.instantiate()
		spawn_this_intro.parent_node = self
		get_parent().add_child(spawn_this_intro)

func set_dimension_for_each_level():
	for i in levels:
		i.dimension = GlobalSapphire.player_savedata.dimension
		i.set_dimension_color(dimension_colors)
	black_baron.dimension = GlobalSapphire.player_savedata.dimension
	black_baron.set_dimension_color(dimension_colors)

func use_transition() -> void:
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(transition,"modulate",Color(0.0,0.0,0.0,0.0),transition_time)
	await new_tween.finished
	can_control = true

func save_global_save_data() -> void:
	var save_data : FileAccess = FileAccess.open("user://global_save_data.txt",FileAccess.WRITE)
	save_data.store_string(str(GlobalSapphire.music_level)+"\n")
	save_data.store_string(str(GlobalSapphire.sound_level)+"\n")
	save_data.store_string(str(TranslationServer.get_locale())+"\n")
	save_data.store_string(str(GlobalSapphire.game_was_completed)+"\n")

func final_boss_completed_check() -> void:
	remove_child(black_baron)
	boss_container.add_child(black_baron)
	black_baron.visible = true
	if levels.size() >= 3:
		boss_container.move_child(black_baron,2)
	elif levels.size() == 2:
		boss_container.move_child(black_baron,1)
	if !level_was_completed(black_baron):
		if levels.size() == 0:
			black_baron.show_boss_look()
			levels = boss_container.get_children()
			ready_for_final_level = true
	else:
		ready_for_final_level = true
		black_baron.show_boss_look()
	black_baron.visible = true
	levels.clear()
	levels = boss_container.get_children()

func _input(event):
	if can_control and !GlobalSapphire.mobile_version:
		if event.is_action_pressed(&"Menu_Down"):
			levels[cur_level].sprite_2d.modulate = Color.WHITE
			back.modulate = active_color
		elif event.is_action_pressed(&"Menu_Up"):
			back.modulate = Color.WHITE
			change_level(0)
		if back.modulate != active_color:
			if event.is_action_pressed(&"Menu_Left"):
				change_level(-1)
			elif event.is_action_pressed(&"Menu_Right"):
				change_level(1)
			elif event.is_action_pressed(&"Menu_Activate"):
				if (ready_for_final_level and levels[cur_level].boss_name == "Black_Baron") or levels[cur_level].boss_name != "Black_Baron":
					activate_level()
			elif event.is_action_pressed(&"Back"):
				back_to_main_menu()
		elif event.is_action_pressed(&"Menu_Activate") or event.is_action_pressed(&"Pause"):
			back_to_main_menu()

func activate_level() -> void:
	can_control = false
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(transition,"modulate",Color(0.0,0.0,0.0,1.0),transition_time)
	await new_tween.finished
	levels[cur_level].activate_level()
	queue_free()

func back_to_main_menu() -> void:
	var main_menu = load("res://Scenes/UI/Main_menu.tscn")
	can_control = false
	var spawn_this = main_menu.instantiate()
	get_parent().add_child(spawn_this)
	queue_free()

func randomize_levels() -> void:
	var reset_randomizing : bool = true
	while reset_randomizing:
		reset_randomizing = false
		var boss_container_children := boss_container.get_children()
		for i in boss_container_children:
			boss_container.move_child(i,randi_range(0,boss_container_children.size()))
			if !level_was_completed(black_baron):
				if level_was_completed(i):
					i.free()
					reset_randomizing = true
					break

func level_was_completed(level_node:Control) -> bool:
	if level_node.boss_name in GlobalSapphire.player_savedata.completed_levels:
		if GlobalSapphire.player_savedata.completed_levels[level_node.boss_name] == 1:
			return true
	else:
		push_warning("There is something wrong with boss_name")
	return false

func unselect_cur_level() -> void:
	levels[cur_level].sprite_2d.modulate = Color.WHITE
	levels[cur_level].hide_level()
	levels[cur_level].unselect_background()

func select_cur_level() -> void:
	levels[cur_level].select_level()
	levels[cur_level].select_background()
	levels[cur_level].sprite_2d.modulate = levels[cur_level].color
	boss_info_left.text = TranslationServer.translate("boss_info "+levels[cur_level].boss_name)
	boss_info_right.text = TranslationServer.translate("info_r "+levels[cur_level].boss_name)
	boss_name_label.text = TranslationServer.translate("boss")+": "+TranslationServer.translate(levels[cur_level].boss_name)
	if levels[cur_level].dimension == 1:
		level_desc.text = TranslationServer.translate("level_desc "+levels[cur_level].boss_name)
	else:
		level_desc.text = TranslationServer.translate("level_desc "+levels[cur_level].boss_name+"_"+str(levels[cur_level].dimension))

func change_level(add_this_number:int) -> void:
	unselect_cur_level()
	cur_level = wrap(cur_level+add_this_number,0,levels.size())
	select_cur_level()
