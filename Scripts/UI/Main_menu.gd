class_name Main_menu
extends Control

@export_color_no_alpha var active_color : Color
@export var menu_options_container : Container
@export var settings_menu : Settings
@export var controls_menu : Controls
@export var credits_menu : Credits
@export var achievements_menu : Achievements
@export var customization_menu : Customization_UI
@export var mods_menu : Mods_UI
@export var new_load_game_menu : New_load_game
@export var transition_time : float = 0.7
@export_group("Resources")
@export var translation_loader : Translation_loader

@onready var transition = $Transition
@onready var mobile_node: Control = $Mobile

var menu_options_labels : Array[Node]
var cur_main_menu_option : int = 0
var end_point
# Epilogue & Prologue
var epilogue_start := preload("res://Scenes/Story/Epilogue_start.tscn")
var epilogue_level := preload("res://Scenes/Levels/Level_Factory_1.tscn")
var prologue_level := preload("res://Scenes/Levels/Level_Prologue.tscn")

enum {EPILOGUE,PROLOGUE,NEW_GAME,LOAD_GAME,ACHIEVEMENTS,SETTINGS,CONTROLS,CUSTOMIZATION,MODS,CREDITS,EXIT}

func _ready():
	menu_options_labels = menu_options_container.get_children()
	if GlobalSapphire.game_was_completed == 0:
		cur_main_menu_option = PROLOGUE
		set_color_for_cur_option(PROLOGUE)
	else:
		cur_main_menu_option = EPILOGUE
		set_color_for_cur_option(EPILOGUE)
		menu_options_container.get_children().front().show()
	translation_loader.activate()
	#if translation_loader.show_debug:
		#debug_test_translation_work()
	TranslationServer.reload_pseudolocalization()
	if OS.has_feature("web"):
		end_point = CREDITS
		menu_options_container.get_children().back().hide()
	else:
		end_point = EXIT
	if OS.has_feature("mobile"):
		$License.hide()
		for i in menu_options_labels:
			i.self_modulate = Color.WHITE
		mobile_node.show()
		GlobalSapphire.mobile_version = true
	else:
		mobile_node.queue_free()
	if OS.has_feature("web") or OS.has_feature("mobile"):
		mods_menu.queue_free()
		$Menu_options/Mods.hide()
		if is_instance_valid(GlobalMods):
			GlobalMods.queue_free()
	GlobalSapphire.player_savedata = null
	GlobalSapphire.cur_hp_refills = 0
	await get_tree().create_timer(0.05).timeout

func _input(event):
	if menu_options_container.visible and !GlobalSapphire.mobile_version:
		if event.is_action_pressed(&"Menu_Down") and cur_main_menu_option < end_point:
			cur_main_menu_option += 1
			if OS.has_feature("web") and cur_main_menu_option == MODS:
				cur_main_menu_option += 1
			set_color_for_cur_option(cur_main_menu_option)
		elif event.is_action_pressed(&"Menu_Up") and cur_main_menu_option > PROLOGUE-GlobalSapphire.game_was_completed:
			cur_main_menu_option -= 1
			if OS.has_feature("web") and cur_main_menu_option == MODS:
				cur_main_menu_option -= 1
			set_color_for_cur_option(cur_main_menu_option)
		elif event.is_action_pressed(&"Menu_Activate"):
			activate_option(cur_main_menu_option)
		elif event.is_action_pressed(&"Back"):
			cur_main_menu_option = EXIT
			set_color_for_cur_option(cur_main_menu_option)

func set_color_for_cur_option(cur_option:int) -> void:
	for i in menu_options_labels:
		i.self_modulate = Color.WHITE
	if menu_options_labels.size() > 0:
		menu_options_labels[cur_option].self_modulate = active_color

func activate_option(cur_option:int) -> void:
	match cur_option:
		EPILOGUE:
			menu_options_container.hide()
			if GlobalSapphire.mobile_version:
				mobile_node.hide()
			await real_transition()
			var spawn_this_epilogue = epilogue_start.instantiate()
			spawn_this_epilogue.parent_node = self
			add_child(spawn_this_epilogue)
		PROLOGUE:
			menu_options_container.hide()
			await real_transition()
			var spawn_this_prologue := prologue_level.instantiate()
			get_parent().add_child(spawn_this_prologue)
			queue_free()
		NEW_GAME:
			menu_options_container.hide()
			if GlobalSapphire.mobile_version:
				mobile_node.hide()
			new_load_game_menu.state = new_load_game_menu.NEW_GAME
			new_load_game_menu.set_default()
			new_load_game_menu.show()
		LOAD_GAME:
			menu_options_container.hide()
			if GlobalSapphire.mobile_version:
				mobile_node.hide()
			new_load_game_menu.state = new_load_game_menu.LOAD_GAME
			new_load_game_menu.set_default()
			new_load_game_menu.show()
		ACHIEVEMENTS:
			await get_tree().create_timer(0.06).timeout
			if GlobalSapphire.mobile_version:
				mobile_node.hide()
			menu_options_container.hide()
			achievements_menu.show()
		SETTINGS:
			if GlobalSapphire.mobile_version:
				mobile_node.hide()
			settings_menu.set_default()
			menu_options_container.hide()
			settings_menu.show()
		CONTROLS:
			await get_tree().create_timer(0.06).timeout
			if GlobalSapphire.mobile_version:
				mobile_node.hide()
			controls_menu.set_default()
			menu_options_container.hide()
			controls_menu.show()
		CUSTOMIZATION:
			await get_tree().create_timer(0.06).timeout
			if GlobalSapphire.mobile_version:
				mobile_node.hide()
			customization_menu.set_default()
			menu_options_container.hide()
			customization_menu.show()
		MODS:
			await get_tree().create_timer(0.06).timeout
			mods_menu.set_default()
			menu_options_container.hide()
			mods_menu.show()
		CREDITS:
			await get_tree().create_timer(0.06).timeout
			if GlobalSapphire.mobile_version:
				mobile_node.hide()
			credits_menu.set_default()
			menu_options_container.hide()
			credits_menu.show()
		EXIT:
			get_tree().quit()

func use_transition() -> void:
	var spawn_this_level = epilogue_level.instantiate()
	get_parent().add_child(spawn_this_level)
	queue_free()

func real_transition() -> bool:
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(transition,"modulate",Color(0.0,0.0,0.0,1.0),transition_time)
	await new_tween.finished
	return true

func _on_achievements_unlocked_all_achievements() -> void:
	$Version/All_achievements.show()
