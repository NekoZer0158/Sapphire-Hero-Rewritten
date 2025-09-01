class_name New_load_game
extends Control

@export var active_color : Color
@export var save_slots : Array[Save_slot]
@export var parent_node : Control
@export var mobile_main_node : Control
@export var transition_time : float = 0.7

@onready var back : Label = $Back
@onready var transition = $Transition
@onready var mobile_node: Control = $Mobile
@onready var label_legend: Label = $Legend/LabelLegend
@onready var legend: Control = $Legend/Legend
@onready var next_page_label: Label = $Next_page
@onready var previous_page_label: Label = $Previous_page
@onready var legend_description: Label = $Legend/Legend/Description

enum {NEW_GAME,LOAD_GAME}
enum {SLOT_1,SLOT_2,SLOT_3,SLOT_4,BACK}

var state : int = NEW_GAME:
	set(value):
		state = value
		if state == LOAD_GAME:
			for i in range(0,save_slots.size()):
				save_slots[i].cur_dimension = dimensions_for_each_slot[i]
				save_slots[i].hide_changeable_dimension()
		else:
			for i in save_slots:
				i.change_dimension(0)
var current_option : int = 0
var dimensions_for_each_slot : Array[int]
var level_selection_scene := preload("res://Scenes/Levels/Level_selection.tscn")
var amount_of_save_slots : int = 0
var amount_of_pages : int = 1
var cur_slots_page : int = 0:
	set(value):
		cur_slots_page = clamp(value,0,amount_of_pages)

const MAX_AMOUNT_OF_SLOTS_ON_PAGE : int = 4

signal game_was_completed()

func _ready():
	set_default()
	amount_of_save_slots = save_slots.size()
	@warning_ignore("integer_division")
	amount_of_pages = int(amount_of_save_slots/MAX_AMOUNT_OF_SLOTS_ON_PAGE)
	dimensions_for_each_slot.resize(amount_of_save_slots)
	dimensions_for_each_slot.fill(1)
	check_saves()
	if OS.has_feature("mobile"):
		back.hide()
		label_legend.hide()
		save_slots[0].select_border(Color.WHITE)
		next_page_label.hide()
		previous_page_label.hide()
		mobile_node.show()
		mobile_node.connect_save_slots()
		legend.hide()
	else:
		mobile_node.queue_free()

func _input(event):
	if visible and !GlobalSapphire.mobile_version:
		if event.is_action_pressed(&"Menu_Down"):
			if current_option < MAX_AMOUNT_OF_SLOTS_ON_PAGE:
				current_option += 1
				set_color_for_cur_option(current_option)
		elif event.is_action_pressed(&"Menu_Up"):
			if current_option > 0:
				current_option -= 1
				set_color_for_cur_option(current_option)
		elif event.is_action_pressed(&"Next_weapon"):
			next_slots_page()
		elif event.is_action_pressed(&"Previous_weapon"):
			previous_slots_page()
		if event.is_action_pressed(&"Menu_Activate"):
			if current_option != BACK:
				activate_option(current_option+(cur_slots_page*MAX_AMOUNT_OF_SLOTS_ON_PAGE))
			else:
				activate_option(current_option,true)
		elif event.is_action_pressed(&"Back"):
			activate_option(BACK,true)
		elif event.is_action_pressed(&"Legend"):
			legend.visible = !legend.visible
		if state == NEW_GAME:
			if event.is_action_pressed(&"Menu_Left"):
				if current_option < MAX_AMOUNT_OF_SLOTS_ON_PAGE:
					save_slots[current_option+(cur_slots_page*MAX_AMOUNT_OF_SLOTS_ON_PAGE)].change_dimension(-1)
			elif event.is_action_pressed(&"Menu_Right"):
				if current_option < MAX_AMOUNT_OF_SLOTS_ON_PAGE:
					save_slots[current_option+(cur_slots_page*MAX_AMOUNT_OF_SLOTS_ON_PAGE)].change_dimension(1)

func set_color_for_cur_option(cur_option:int) -> void:
	for i in save_slots:
		i.select_border(Color.WHITE)
	back.self_modulate = Color.WHITE
	if save_slots.size() > 0 and cur_option < MAX_AMOUNT_OF_SLOTS_ON_PAGE:
		save_slots[cur_option+cur_slots_page*MAX_AMOUNT_OF_SLOTS_ON_PAGE].select_border(active_color)
	else:
		back.self_modulate = active_color

func check_saves() -> void:
	for i in range(0,amount_of_save_slots):
		check_save(i+1)

func next_slots_page() -> void:
	if cur_slots_page < amount_of_pages-1:
		cur_slots_page += 1
		if !GlobalSapphire.mobile_version:
			if cur_slots_page*MAX_AMOUNT_OF_SLOTS_ON_PAGE+MAX_AMOUNT_OF_SLOTS_ON_PAGE == amount_of_save_slots:
				next_page_label.hide()
			previous_page_label.show()
		for i in range(0,MAX_AMOUNT_OF_SLOTS_ON_PAGE):
			save_slots[i+((cur_slots_page-1)*MAX_AMOUNT_OF_SLOTS_ON_PAGE)].hide()
			save_slots[i+cur_slots_page*MAX_AMOUNT_OF_SLOTS_ON_PAGE].show()
		if !GlobalSapphire.mobile_version:
			set_color_for_cur_option(current_option)

func previous_slots_page() -> void:
	if cur_slots_page > 0:
		cur_slots_page -= 1
		if !GlobalSapphire.mobile_version:
			next_page_label.show()
			if cur_slots_page == 0:
				previous_page_label.hide()
		for i in range(0,MAX_AMOUNT_OF_SLOTS_ON_PAGE):
			save_slots[i+cur_slots_page*MAX_AMOUNT_OF_SLOTS_ON_PAGE].show()
			save_slots[i+((cur_slots_page+1)*MAX_AMOUNT_OF_SLOTS_ON_PAGE)].hide()
		if !GlobalSapphire.mobile_version:
			set_color_for_cur_option(current_option)

func check_save(save_number:int) -> void:
	var slot_path : String = "user://Slot_"+str(save_number)+".json"
	var cur_save_file : Savedata
	if FileAccess.file_exists(slot_path):
		var file := FileAccess.open(slot_path,FileAccess.READ)
		var json_string : String
		var json_data
		json_string = file.get_line()
		file.close()
		json_data = JSON.parse_string(json_string)
		cur_save_file = Savedata.new()
		cur_save_file.save_number = save_number
		cur_save_file.completed_levels = json_data.completed_levels.duplicate(true)
		cur_save_file.player_hp_refills = json_data.player_hp_refills.duplicate(true)
		cur_save_file.other_data = json_data.other_data.duplicate(true)
		if json_data.has("dimension"):
			cur_save_file.dimension = json_data.dimension
			dimensions_for_each_slot[save_number-1] = int(json_data.dimension)
		if cur_save_file.completed_levels["Black_Baron"] == 1 and GlobalSapphire.game_was_completed == 0:
			GlobalSapphire.game_was_completed = 1
			game_was_completed.emit()
		save_slots[save_number-1].set_data_for_the_slot(cur_save_file)
	else:
		save_slots[save_number-1].set_no_savedata()

func activate_option(cur_option:int,force_back:bool=false) -> void:
	if force_back:
		back_to_main_menu()
		return
	if (cur_option != BACK) or (cur_option == BACK and cur_slots_page == 1):
		match state:
			NEW_GAME:
				save_data(cur_option+1)
			LOAD_GAME:
				load_data(cur_option+1)
	else:
		back_to_main_menu()

func back_to_main_menu() -> void:
	await get_tree().create_timer(0.06).timeout
	hide()
	parent_node.show()

func set_default() -> void:
	current_option = 0
	legend_description.text = TranslationServer.translate("legend_description_1")+"\n"+TranslationServer.translate("legend_description_2")
	var i_slots : int = 0
	while cur_slots_page != 0:
		previous_slots_page()
		i_slots += 1
		if i_slots == 5:
			push_error("Too many iterations")
			get_tree().quit()
	for i in save_slots:
		i.translate_save_()
	if GlobalSapphire.mobile_version:
		mobile_node.set_default()
		save_slots[0].select_border(Color.WHITE)
	else:
		set_color_for_cur_option(current_option)

func save_data(save_slot_number:int) -> void:
	var slot_path : String = "user://Slot_"+str(save_slot_number)+".json"
	var save_file := FileAccess.open(slot_path,FileAccess.WRITE)
	var test_save_data := Savedata.new()
	var save_data_json := {
		"save_number":save_slot_number,
		"completed_levels":test_save_data.completed_levels.duplicate(true),
		"player_hp_refills":test_save_data.player_hp_refills.duplicate(true),
		"other_data":test_save_data.other_data.duplicate(true),
		"dimension":save_slots[save_slot_number-1].cur_dimension
	}
	test_save_data.dimension = save_slots[save_slot_number-1].cur_dimension
	var json_string := JSON.stringify(save_data_json)
	save_file.store_line(json_string)
	save_file.close()
	GlobalSapphire.player_savedata = test_save_data
	GlobalSapphire.player_savedata.save_number = save_slot_number
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(transition,"modulate",Color(0.0,0.0,0.0,1.0),transition_time)
	await new_tween.finished
	var level_selection = level_selection_scene.instantiate()
	get_parent().get_parent().add_child(level_selection)
	get_parent().queue_free()

func load_data(save_slot_number:int) -> void:
	var slot_path : String = "user://Slot_"+str(save_slot_number)+".json"
	if FileAccess.file_exists(slot_path):
		var file := FileAccess.open(slot_path,FileAccess.READ)
		var json_string : String
		var json_data
		json_string = file.get_line()
		file.close()
		json_data = JSON.parse_string(json_string)
		GlobalSapphire.player_savedata = Savedata.new()
		GlobalSapphire.player_savedata.save_number = save_slot_number
		GlobalSapphire.player_savedata.completed_levels = json_data.completed_levels.duplicate(true)
		GlobalSapphire.player_savedata.player_hp_refills = json_data.player_hp_refills.duplicate(true)
		GlobalSapphire.player_savedata.other_data = json_data.other_data.duplicate(true)
		if json_data.has("dimension"):
			GlobalSapphire.player_savedata.dimension = json_data.dimension
		var new_tween = get_tree().create_tween()
		new_tween.tween_property(transition,"modulate",Color(0.0,0.0,0.0,1.0),transition_time)
		await new_tween.finished
		var level_selection = level_selection_scene.instantiate()
		level_selection.first_time = false
		get_parent().get_parent().add_child(level_selection)
		get_parent().queue_free()
	else:
		if OS.has_feature("mobile"):
			for i in save_slots:
				i.select_border(Color.WHITE)
		#push_warning("There is no save_data")
