class_name Settings
extends Control

@export var active_color : Color
@export var parent_node : Control
@export var mobile_parent_node : Control
@export var settings_options : Container
@export_group("Audio")
@export var default_music_for_test : AudioStreamWAV
@export var music_progress_bar : ProgressBar
@export var sound_progress_bar : ProgressBar
@export var sound_stream_player : AudioStreamPlayer
@export var music_stream_player : AudioStreamPlayer

@onready var cur_language = $Settings_options/Language/Cur_Language
@onready var music = $Settings_options/Music
@onready var sound = $Settings_options/Sound
@onready var language = $Settings_options/Language
@onready var mobile_node: Control = $Mobile
@onready var vsync_on_off_label: Label = $Settings_options/VSync/VSync_on_off

var settings_option : int = 0
var settings_options_labels : Array[Node]

enum {LANGUAGE,MUSIC,SOUND,VSYNC,BACK}

signal hide_settings()

func _ready():
	if !is_instance_valid(parent_node):
		push_error("No parent_node")
	check_global_save_data()
	change_translation()
	set_vsync(GlobalSapphire.vsync)
	settings_options_labels = settings_options.get_children()
	music_progress_bar.value = GlobalSapphire.music_level
	sound_progress_bar.value = GlobalSapphire.sound_level
	check_language()
	AudioServer.set_bus_volume_db(1,GlobalSapphire.min_audio_value+GlobalSapphire.sound_level*4)
	music_stream_player.volume_db = -60+GlobalSapphire.music_level*4
	set_color_for_cur_option(0)
	check_and_set_mobile_version()

func check_and_set_mobile_version() -> void:
	if !OS.has_feature("mobile"):
		mobile_node.queue_free()
	else:
		settings_options.hide()
		music_progress_bar = $Mobile/Settings_options/Music/ProgressBar_Music
		sound_progress_bar = $Mobile/Settings_options/Sound/ProgressBar_Sound
		cur_language = $Mobile/Settings_options/Language/Cur_Language
		music = $Mobile/Settings_options/Music
		sound = $Mobile/Settings_options/Sound
		language = $Mobile/Settings_options/Language
		music_progress_bar.value = GlobalSapphire.music_level
		sound_progress_bar.value = GlobalSapphire.sound_level
		mobile_node.show()

func set_default() -> void:
	settings_option = 0
	change_translation()
	set_vsync(GlobalSapphire.vsync)
	if GlobalSapphire.mobile_version:
		settings_options.hide()
		check_mobile_language()
		mobile_node.show()
	else:
		check_language()
	set_color_for_cur_option(0)

func change_translation() -> void:
	language.text = TranslationServer.translate("Language")+":"
	music.text = TranslationServer.translate("Music")+":"
	sound.text = TranslationServer.translate("Sound")+":"
	match GlobalSapphire.vsync:
		0:
			vsync_on_off_label.text = "<"+TranslationServer.translate("off")
		1:
			vsync_on_off_label.text = TranslationServer.translate("on")+">"

func check_language() -> void:
	if GlobalSapphire.cur_locale_int > 0 and GlobalSapphire.cur_locale_int < GlobalSapphire.cur_locales.size()-1:
		if TranslationServer.get_locale() in GlobalSapphire.only_ui_locales:
			cur_language.text = "<"+TranslationServer.translate("Language_name")+"(UI only)>"
		else:
			cur_language.text = "<"+TranslationServer.translate("Language_name")+">"
	elif  GlobalSapphire.cur_locale_int > 0:
		if TranslationServer.get_locale() in GlobalSapphire.only_ui_locales:
			cur_language.text = "<"+TranslationServer.translate("Language_name")+"(UI only)"
		else:
			cur_language.text = "<"+TranslationServer.translate("Language_name")
	elif GlobalSapphire.cur_locale_int < GlobalSapphire.cur_locales.size()-1:
		if TranslationServer.get_locale() in GlobalSapphire.only_ui_locales:
			cur_language.text = TranslationServer.translate("Language_name")+"(UI only)>"
		else:
			cur_language.text = TranslationServer.translate("Language_name")+">"
	else:
		cur_language.text = TranslationServer.translate("Language_name")
	save_global_save_data()
	change_translation()

func check_mobile_language() -> void:
	if GlobalSapphire.mobile_version:
		if TranslationServer.get_locale() in GlobalSapphire.only_ui_locales:
			cur_language.text = TranslationServer.translate("Language_name")+"(UI only)"
		else:
			cur_language.text = TranslationServer.translate("Language_name")
	else:
		push_warning("Nope")

func _input(event):
	if visible:
		if event.is_action_pressed(&"Menu_Down") and settings_option < BACK:
			settings_option += 1
			set_color_for_cur_option(settings_option)
		elif event.is_action_pressed(&"Menu_Up") and settings_option > 0:
			settings_option -= 1
			set_color_for_cur_option(settings_option)
		elif event.is_action_pressed(&"Menu_Left"):
			match settings_option:
				LANGUAGE:
					if GlobalSapphire.cur_locale_int > 0:
						GlobalSapphire.cur_locale_int -= 1
						TranslationServer.set_locale(GlobalSapphire.cur_locales[GlobalSapphire.cur_locale_int])
					check_language()
				MUSIC:
					if GlobalSapphire.music_level > 0:
						change_music_level(-1)
				SOUND:
					if GlobalSapphire.sound_level > 0:
						change_sound_level(-1)
				VSYNC:
					set_vsync(1)
					save_global_save_data()
		elif event.is_action_pressed(&"Menu_Right"):
			match settings_option:
				LANGUAGE:
					if GlobalSapphire.cur_locale_int < GlobalSapphire.cur_locales.size()-1:
						GlobalSapphire.cur_locale_int += 1
						TranslationServer.set_locale(GlobalSapphire.cur_locales[GlobalSapphire.cur_locale_int])
					check_language()
				MUSIC:
					if GlobalSapphire.music_level < 15:
						change_music_level(1)
				SOUND:
					if GlobalSapphire.sound_level < 15:
						change_sound_level(1)
				VSYNC:
					set_vsync(0)
					save_global_save_data()
		if event.is_action_pressed(&"Menu_Activate"):
			activate_option(settings_option)
		elif event.is_action_pressed(&"Back"):
			stop_music()
			activate_option(BACK)

func set_vsync(new_value : int) -> void:
	GlobalSapphire.vsync = new_value
	DisplayServer.window_set_vsync_mode(GlobalSapphire.vsync)
	match GlobalSapphire.vsync:
		0:
			vsync_on_off_label.text = "<"+TranslationServer.translate("off")
		1:
			vsync_on_off_label.text = TranslationServer.translate("on")+">"

func change_music_level(add_this_value:int) -> void:
	GlobalSapphire.music_level += add_this_value
	music_stream_player.volume_db = -60+GlobalSapphire.music_level*4
	music_progress_bar.value = GlobalSapphire.music_level
	save_global_save_data()

func change_sound_level(add_this_value:int) -> void:
	GlobalSapphire.sound_level += add_this_value
	sound_progress_bar.value = GlobalSapphire.sound_level
	AudioServer.set_bus_volume_db(1,GlobalSapphire.min_audio_value+GlobalSapphire.sound_level*4)
	sound_stream_player.play()
	save_global_save_data()

func activate_option(cur_option:int) -> void:
	match cur_option:
		BACK:
			await get_tree().create_timer(0.06).timeout
			hide()
			if GlobalSapphire.mobile_version:
				mobile_parent_node.show()
			parent_node.show()
			emit_signal("hide_settings")

func set_color_for_cur_option(cur_option:int) -> void:
	for i in settings_options_labels:
		i.self_modulate = Color.WHITE
	if settings_options_labels.size() > 0:
		settings_options_labels[cur_option].self_modulate = active_color
	match cur_option:
		LANGUAGE:
			stop_music()
		MUSIC:
			activate_music()
		SOUND:
			stop_music()
			sound_stream_player.play()

func activate_music() -> void:
	music_stream_player.stream = default_music_for_test
	music_stream_player.play()

func stop_music() -> void:
	music_stream_player.stop()

func can_open_global_save_data() -> bool:
	var save_data := FileAccess.file_exists("user://global_save_data.txt")
	return save_data

func check_global_save_data() -> void:
	var save_data : FileAccess
	if can_open_global_save_data():
		var cur_line : String
		save_data  = FileAccess.open("user://global_save_data.txt",FileAccess.READ)
		if save_data != null:
			cur_line = save_data.get_line()
			if check_line(cur_line):
				return
			GlobalSapphire.music_level = int(cur_line)
			cur_line = save_data.get_line()
			if check_line(cur_line):
				return
			GlobalSapphire.sound_level = int(cur_line)
			cur_line = save_data.get_line()
			if check_line(cur_line):
				return
			TranslationServer.set_locale(cur_line)
			cur_line = save_data.get_line()
			if check_line(cur_line):
				return
			GlobalSapphire.game_was_completed = int(cur_line)
			cur_line = save_data.get_line()
			if check_line(cur_line):
				return
			GlobalSapphire.vsync = int(cur_line)
	else:
		save_global_save_data()

func check_line(cur_line:String) -> bool:
	if cur_line == "":
		push_warning("No line")
		return true
	return false

func save_global_save_data() -> void:
	var save_data : FileAccess = FileAccess.open("user://global_save_data.txt",FileAccess.WRITE)
	save_data.store_string(str(GlobalSapphire.music_level)+"\n")
	save_data.store_string(str(GlobalSapphire.sound_level)+"\n")
	save_data.store_string(str(TranslationServer.get_locale())+"\n")
	save_data.store_string(str(GlobalSapphire.game_was_completed)+"\n")
	save_data.store_string(str(GlobalSapphire.vsync)+"\n")
