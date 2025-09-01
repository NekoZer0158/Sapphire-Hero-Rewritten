class_name Customization_UI
extends Control

@export var parent_node : Control
@export var mobile_parent_node : Control
@export var options : Array[Node]
@export_group("Colors")
@export_color_no_alpha var color : Color
#@export_color_no_alpha var color_background : Color

@onready var cur_customization_label := $Options_container/Cur_customization
@onready var custom_text := $Custom_text
@onready var tab_container := $Options_container/TabContainer
@onready var mobile_node: Control = $Mobile

var cur_option : int = 0
var cur_something_array_index : int = 0
var cur_something : Array[int] = []
var something_size : Array[int] = []
var containers_names : Array[String] = []
var hbox_container_children : Array[Array] = []

enum {HEAD,HP_REFILL,PROGRESS_BAR}
enum {CUR_CUSTOMIZATION,TAB_CONTAINER,BACK}

const SEPARATION_FOR_MOBILE : int = 175

func _ready():
	for i in get_tree().get_nodes_in_group("Customization_slot"):
		i.background.modulate = color*0.35
	for i in tab_container.get_children():
		cur_something.append(0)
		hbox_container_children.append(i.get_children())
		containers_names.append(i.name)
		something_size.append(i.get_child_count())
	set_custom_name(0)
	check_mods_folder()
	if !check_customization_data():
		GlobalSapphire.customization_data = Customization_data.new()
		save_customization_data()
	else:
		load_customization_data()
	select_customization_option()
	check_if_content_can_be_unlocked()
	if !OS.has_feature("mobile"):
		mobile_node.queue_free()
	else:
		mobile_node.connect_everything(hbox_container_children)
		$Options_container/TabContainer/Head["theme_override_constants/separation"] = SEPARATION_FOR_MOBILE
		$Options_container/TabContainer/HP_refill["theme_override_constants/separation"] = SEPARATION_FOR_MOBILE
		$Options_container/TabContainer/Progress_bar["theme_override_constants/separation"] = SEPARATION_FOR_MOBILE
		$Options_container/TabContainer/Plane/Customization_single.hide()
		$Options_container/TabContainer/Head/Customization_head7.hide()
		for i in get_tree().get_nodes_in_group("Spanish_UI"):
			i.hide()
		mobile_node.show()
	if OS.has_feature("mobile") or OS.has_feature("web"):
		for i in get_tree().get_nodes_in_group("Spanish_UI"):
			i.hide()

func set_default() -> void:
	cur_option = 0
	tab_container.current_tab = 0
	cur_something_array_index = 0
	set_color_for_cur_option(0)
	set_custom_name(0)
	if GlobalSapphire.mobile_version:
		mobile_node.show()
		mobile_node.tsb_left.hide()
		mobile_node.tsb_right.show()
	custom_text.text = hbox_container_children[cur_something_array_index][cur_something[cur_something_array_index]].text[0]

func check_if_content_can_be_unlocked() -> void:
	var path : String = ProjectSettings.globalize_path("user://")
	path = path.reverse().split("/",true,2)[2].reverse()
	var d = DirAccess.dir_exists_absolute(path+"/Bullets that split the sky Dilogy/")
	if d:
		unlock_this_folder_name("Spanish")
		unlock_this_folder_name("BTSTSD")
	d = DirAccess.dir_exists_absolute(path+"/Sapphire Hero 2 Rewritten/")
	if d:
		unlock_this_folder_name("NMR_7")
		unlock_this_folder_name("Sequel_unlock")

func unlock_this_folder_name(folder_name:String) -> void:
	for i in hbox_container_children:
		for j in i:
			if j.folder_name == folder_name:
				j.unlocked = true

func _input(event):
	if visible:
		if event.is_action_pressed(&"Menu_Down") and cur_option < BACK:
			cur_option += 1
			set_color_for_cur_option(cur_option)
		elif event.is_action_pressed(&"Menu_Up") and cur_option > CUR_CUSTOMIZATION:
			cur_option -= 1
			set_color_for_cur_option(cur_option)
		elif event.is_action_pressed(&"Menu_Activate"):
			activate_option(cur_option)
		elif event.is_action_pressed(&"Menu_Left"):
			menu_left_pressed(-1)
		elif event.is_action_pressed(&"Menu_Right"):
			menu_right_pressed(1)
		elif event.is_action_pressed(&"Back"):
			activate_option(BACK)

func menu_left_pressed(number:int) -> void:
	if cur_option == TAB_CONTAINER:
		change_cur_customization(number)
	if cur_option == CUR_CUSTOMIZATION and cur_something_array_index > 0:
		change_customization_tab_option(number)

func menu_right_pressed(number:int) -> void:
	if cur_option == TAB_CONTAINER:
		change_cur_customization(number)
	if cur_option == CUR_CUSTOMIZATION and cur_something_array_index < containers_names.size()-1:
		change_customization_tab_option(number)

func change_cur_customization(number:int) -> void:
	unselect_a_background()
	hbox_container_children[cur_something_array_index][cur_something[cur_something_array_index]].unselect()
	cur_something[tab_container.current_tab] = wrapi(cur_something[tab_container.current_tab]+number,0,something_size[tab_container.current_tab])
	select_customization_option()

func change_customization_tab_option(number:int) -> void:
	cur_something_array_index += number
	set_custom_name(cur_something_array_index)
	select_customization_option(false)

func set_custom_name(number:int) -> void:
	if containers_names.size() == 0 or GlobalSapphire.mobile_version:
		cur_customization_label.text = TranslationServer.translate(containers_names[number])
	elif number == 0:
		cur_customization_label.text = TranslationServer.translate(containers_names[number])+">"
	elif number > 0 and number < containers_names.size()-1:
		cur_customization_label.text = "<"+TranslationServer.translate(containers_names[number])+">"
	elif number > 0:
		cur_customization_label.text = "<"+TranslationServer.translate(containers_names[number])
	tab_container.current_tab = number

func check_mods_folder() -> void:
	if OS.has_feature("standalone"):
		for i in range(1,4):
			var current_head := Custom_textures_loader.load_one_texture(OS.get_executable_path().get_base_dir()+"/Mods/Heads","Head_"+str(i)+".png")
			if current_head != null:
				var cur_head := Custom_skin_loader.load_head(current_head,i,"Head","Head_",true)
				add_child_and_change_background_color($Options_container/TabContainer/Head,cur_head)
				hbox_container_children[HEAD].append(cur_head)
				something_size[HEAD] += 1
			var cur_UI := Custom_textures_loader.load_textures_from_folder("UI","UI_"+str(i))
			if cur_UI.size() > 0:
				if "HP_refill" in cur_UI:
					var cur_HP_refiller := Custom_skin_loader.load_head(cur_UI["HP_refill"],i,"HP_refill","UI_",false)
					add_child_and_change_background_color($Options_container/TabContainer/HP_refill,cur_HP_refiller)
					hbox_container_children[HP_REFILL].append(cur_HP_refiller)
					something_size[HP_REFILL] += 1
				if "Progress_bar" in cur_UI:
					var cur_progress_bar := Custom_UI_loader.load_progress_bar(cur_UI["Progress_bar"],i,"Progress_bar","UI_")
					add_child_and_change_background_color($Options_container/TabContainer/Progress_bar,cur_progress_bar)
					hbox_container_children[PROGRESS_BAR].append(cur_progress_bar)
					something_size[PROGRESS_BAR] += 1

func add_child_and_change_background_color(node:Node,custom_slot:Customization_select) -> void:
	node.add_child(custom_slot)
	custom_slot.background.modulate = color*0.35

func unselect_a_background() -> void:
	var this = hbox_container_children[cur_something_array_index][cur_something[cur_something_array_index]]
	this.background.modulate = color*0.35

func set_color_for_cur_option(current_option:int) -> void:
	var this = hbox_container_children[cur_something_array_index][cur_something[cur_something_array_index]]
	this.unselect()
	for i in options:
		i.self_modulate = Color.WHITE
	if options.size() > 0:
		if options[current_option] is TabContainer:
			this.select(color)
		else:
			options[current_option].self_modulate = color

func select_customization_option(select_this:bool=true) -> void:
	var this = hbox_container_children[cur_something_array_index][cur_something[cur_something_array_index]]
	this.background.modulate = color*0.65
	if select_this:
		this.select(color)
	if this.unlocked:
		custom_text.text = this.text[0]
	else:
		custom_text.text = this.how_to_unlock_text
	save_customization_data()

func activate_option(current_option:int) -> void:
	match current_option:
		BACK:
			await get_tree().create_timer(0.06).timeout
			hide()
			if GlobalSapphire.mobile_version:
				mobile_parent_node.show()
			parent_node.show()

func check_customization_data() -> bool:
	var custom_path : String = "user://Customization.json"
	if FileAccess.file_exists(custom_path):
		return true
	return false

func save_customization_data() -> void:
	var custom_path : String = "user://Customization.json"
	var save_file := FileAccess.open(custom_path,FileAccess.WRITE)
	var save_data_json := {
		"customization_info":GlobalSapphire.customization_data.customization_info
	}
	var json_string := JSON.stringify(save_data_json)
	save_file.store_line(json_string)
	save_file.close()
	
func load_customization_data() -> void:
	var custom_path : String = "user://Customization.json"
	if FileAccess.file_exists(custom_path):
		var file := FileAccess.open(custom_path,FileAccess.READ)
		var json_string : String
		var json_data
		json_string = file.get_line()
		file.close()
		json_data = JSON.parse_string(json_string)
		GlobalSapphire.customization_data = Customization_data.new()
		GlobalSapphire.customization_data.customization_info = json_data.customization_info.duplicate(true)
		select_loaded_data()
	else:
		push_warning("There is no customization_data")

func select_loaded_data() -> void:
	var cur_container_index : int = 0
	var cur_j_index : int = 0
	for i in hbox_container_children:
		cur_j_index = 0
		for j in i:
			if not containers_names[cur_container_index] in GlobalSapphire.customization_data.customization_info:
				GlobalSapphire.customization_data.customization_info[containers_names[cur_container_index]] = "Default"
			if j.folder_name == GlobalSapphire.customization_data.customization_info[containers_names[cur_container_index]]:
				cur_something[cur_container_index] = cur_j_index
				j.background.modulate = color*0.65
			cur_j_index += 1
		cur_container_index += 1
