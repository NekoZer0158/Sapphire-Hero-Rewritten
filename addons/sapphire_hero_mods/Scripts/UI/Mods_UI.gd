class_name Mods_UI
extends Control

@export var level_loader : Node
@export var show_this_after_hiding : Control
@export var check_this_folder_for_mods : String
@export var mod_loaders_folder_path : String
@export_group("Colors")
@export_color_no_alpha var color : Color = Color("418bd1")

@onready var controls: Control = $Controls
@onready var tab_container: TabContainer = $TabContainer
@onready var ready_mods: GridContainer = $"TabContainer/Ready mods"
#@onready var custom_player: GridContainer = $"TabContainer/Custom player"
@onready var levels: GridContainer = $TabContainer/Levels
#@onready var libraries: GridContainer = $TabContainer/Libraries
@onready var label_no_mod_loader: Label = $LabelNoModLoader

var ready_mods_child_count : int
var levels_child_count : int
var can_control : bool = true

var mod_index_x : int = 0:
	set(value):
		var previous_value : int = mod_index_x
		var child_count : int
		match tab_container.current_tab:
			READY_MODS:
				child_count = ready_mods_child_count
			LEVELS:
				child_count = levels_child_count
		if child_count-mod_index_y <= 3:
			mod_index_x = clamp(value,mod_index_y*3,(mod_index_y*3)+((child_count-1)%3))
		else:
			mod_index_x = clamp(value,mod_index_y*3,(mod_index_y*3)+2)
		if previous_value == mod_index_x or !is_instance_valid(cur_mod):
			return
		if mod_index_x >= child_count:
			mod_index_x = child_count-1
		else:
			cur_mod.modulate = GRAY
			match tab_container.current_tab:
				READY_MODS:
					cur_mod = ready_mods.get_child(mod_index_x)
				LEVELS:
					cur_mod = levels.get_child(mod_index_x)
			cur_mod.modulate = Color.WHITE
		if mod_index_x > MAX_AMOUNT_OF_MODS_PER_PAGE*(cur_page+1):
			cur_page += 1
			match tab_container.current_tab:
				READY_MODS:
					for i in range(0,MAX_AMOUNT_OF_MODS_PER_PAGE*cur_page):
						ready_mods.get_child(i).hide()
				LEVELS:
					for i in range(0,MAX_AMOUNT_OF_MODS_PER_PAGE*cur_page):
						levels.get_child(i).hide()
var mod_index_y : int = 0:
	set(value):
		var child_count : int
		match tab_container.current_tab:
			READY_MODS:
				child_count = ready_mods_child_count
			LEVELS:
				child_count = levels_child_count
		mod_index_y = clamp(value,0,floor((child_count-1)/MAX_AMOUNT_OF_MODS_PER_LINE))
var cur_mod : Mod_interface
var loaded_activated_mods : Array[String] = []
var cur_page : int = 0

enum{READY_MODS,LEVELS}

const MAX_AMOUNT_OF_MODS_PER_PAGE : int = 18
const MAX_AMOUNT_OF_MODS_PER_LINE : float = 3.0
const GRAY := Color(0.5,0.5,0.5)
const MOD_INTERFACE = preload("res://addons/sapphire_hero_mods/Scenes/UI/Mod_interface.tscn")
const MOD_INTERFACE_LEVEL = preload("res://addons/sapphire_hero_mods/Scenes/UI/Mod_interface_level.tscn")
const ALL_MODS_FOLDER : String = "res://Mods/"

func _ready() -> void:
	if OS.has_feature("standalone"):
		if check_mod_loaders():
			check_and_load_mods()
			GlobalMods.mods_were_loaded = true
	ready_mods_child_count = ready_mods.get_child_count()
	levels_child_count = levels.get_child_count()
	set_default()

func check_and_load_mods() -> void:
	load_all_mods_in_this_folder("Ready mods",ready_mods)
	#load_all_mods_in_this_folder("Custom player",custom_player)
	load_all_mods_in_this_folder("Levels",levels)
	#load_all_mods_in_this_folder("Libraries",libraries)
	check_if_every_activated_mod_is_loaded()
	if ready_mods.get_child_count() > 0:
		cur_mod = ready_mods.get_child(0)
		cur_mod.modulate = Color.WHITE

func check_mod_loaders() -> bool:
	var mod_loaders : int = 0
	var main_folder := OS.get_executable_path().get_base_dir()
	if DirAccess.dir_exists_absolute(main_folder+"/"+mod_loaders_folder_path):
		for i in DirAccess.get_files_at(main_folder+"/"+mod_loaders_folder_path):
			if i.ends_with(".pck"):
				if !ProjectSettings.load_resource_pack(main_folder+"/"+mod_loaders_folder_path+"/"+i,true):
					push_error("Failed to load a mod loader")
				mod_loaders += 1
			else:
				push_error("Not a pck file")
	if mod_loaders == 0:
		label_no_mod_loader.show()
		push_error("No mod loaders found")
		return false
	return true

func _input(event):
	if visible and can_control:
		if event.is_action_pressed(&"Previous_weapon"):
			tab_container.current_tab = clamp(tab_container.current_tab-1,0,tab_container.current_tab)
			reset_current_mod_index()
		elif event.is_action_pressed(&"Next_weapon"):
			tab_container.current_tab = clamp(tab_container.current_tab+1,0,1)
			reset_current_mod_index()
		elif event.is_action_pressed(&"Show_hide_controls"):
			controls.visible = !controls.visible
		elif event.is_action_pressed(&"Menu_Activate"):
			if cur_mod != null:
				if cur_mod is Mod_interface_level:
					can_control = false
				cur_mod.activate()
		elif event.is_action_pressed(&"Menu_Right"):
			mod_index_x += 1
		elif event.is_action_pressed(&"Menu_Left"):
			mod_index_x -= 1
		elif event.is_action_pressed(&"Menu_Down"):
			var previous_value_y := mod_index_y
			mod_index_y += 1
			if previous_value_y != mod_index_y:
				mod_index_x += 3
		elif event.is_action_pressed(&"Menu_Up"):
			var previous_value_y := mod_index_y
			mod_index_y -= 1
			if previous_value_y != mod_index_y:
				mod_index_x -= 3
		elif event.is_action_pressed(&"Back"):
			await get_tree().create_timer(0.06).timeout
			hide()
			show_this_after_hiding.show()

func check_if_every_activated_mod_is_loaded() -> void:
	if loaded_activated_mods.size() < GlobalMods.activated_mods.size():
		var remove_those_mods_from_acitvated : Array[String] = []
		for i in GlobalMods.activated_mods:
			if not i in loaded_activated_mods:
				remove_those_mods_from_acitvated.append(i)
		for i in remove_those_mods_from_acitvated:
			GlobalMods.activated_mods.erase(i)

func load_all_mods_in_this_folder(subfolder:String,parent_node:GridContainer) -> void:
	var main_folder := OS.get_executable_path().get_base_dir()+"/"+check_this_folder_for_mods+subfolder
	var dir := DirAccess.open(main_folder)
	var mod_files := dir.get_files_at(main_folder)
	var loaded_mods : PackedStringArray
	if !GlobalMods.mods_were_loaded:
		for i in mod_files:
			if !ProjectSettings.load_resource_pack(main_folder+"/"+i,true):
				push_error("Failed to load a mod")
	if mod_files.size() > 0:
		dir = DirAccess.open(ALL_MODS_FOLDER+subfolder)
		loaded_mods = DirAccess.get_directories_at(ALL_MODS_FOLDER+subfolder)
		for i in loaded_mods:
			if subfolder == "Levels":
				spawn_mod_interface(ALL_MODS_FOLDER+subfolder+"/"+i,parent_node,MOD_INTERFACE_LEVEL)
			else:
				spawn_mod_interface(ALL_MODS_FOLDER+subfolder+"/"+i,parent_node,MOD_INTERFACE)

func spawn_mod_interface(mod_folder_path:String,parent_node:GridContainer,mod_interface:PackedScene) -> void:
	var new_mod_interface : Mod_interface = mod_interface.instantiate()
	var mod_icon := load(mod_folder_path+"/Icon.png")
	var mod_description := load_mod_csv_file(mod_folder_path)
	new_mod_interface.color = color
	parent_node.add_child(new_mod_interface)
	new_mod_interface.set_everything(load(mod_folder_path+"/Icon.png"),mod_description,mod_folder_path+"/Main.tscn")
	new_mod_interface.modulate = Color(0.5,0.5,0.5)
	if new_mod_interface is Mod_interface_level:
		new_mod_interface.start_this_level.connect(level_loader.load_level)
	if mod_folder_path+"/Main.tscn" in GlobalMods.activated_mods:
		loaded_activated_mods.append(mod_folder_path+"/Main.tscn")
		new_mod_interface.activate(false)

func load_mod_csv_file(mod_folder_path:String) -> String:
	var mod_description : String = ""
	var TXT_file := FileAccess.open(mod_folder_path+"/Description.txt",FileAccess.READ)
	while TXT_file.get_position() < TXT_file.get_length():
		mod_description += TXT_file.get_line()+"\n"
	TXT_file.close()
	return mod_description

func set_default() -> void:
	if ready_mods.get_child_count() > 0:
		cur_mod = ready_mods.get_child(0)
	reset_current_mod_index()

func reset_current_mod_index() -> void:
	mod_index_x = 0
	mod_index_y = 0
	var tab_children : Array[Node]
	match tab_container.current_tab:
		READY_MODS:
			tab_children = ready_mods.get_children()
		LEVELS:
			tab_children = levels.get_children()
	for i in tab_children:
		i.modulate = GRAY
	if tab_children.size() > 0:
		cur_mod = tab_children[0]
		tab_children[0].modulate = Color.WHITE
