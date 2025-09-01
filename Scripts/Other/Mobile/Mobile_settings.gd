extends Control

@export var settings_node : Settings
@onready var language_label: Label = $Settings_options/Language
@onready var music_label: Label = $Settings_options/Music
@onready var sound_label: Label = $Settings_options/Sound

enum {LANGUAGE,MUSIC,SOUND,VSYNC,BACK}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Language_left"):
		if GlobalSapphire.cur_locale_int > 0:
			GlobalSapphire.cur_locale_int -= 1
			TranslationServer.set_locale(GlobalSapphire.cur_locales[GlobalSapphire.cur_locale_int])
		settings_node.check_mobile_language()
		TranslationServer.reload_pseudolocalization()
		language_label.text = TranslationServer.translate("Language")+":"
		music_label.text = TranslationServer.translate("Music")+":"
		sound_label.text = TranslationServer.translate("Sound")+":"
	elif event.is_action_pressed(&"Language_right"):
		if GlobalSapphire.cur_locale_int < GlobalSapphire.cur_locales.size()-1:
			GlobalSapphire.cur_locale_int += 1
			TranslationServer.set_locale(GlobalSapphire.cur_locales[GlobalSapphire.cur_locale_int])
		settings_node.check_mobile_language()
		TranslationServer.reload_pseudolocalization()
		language_label.text = TranslationServer.translate("Language")+":"
		music_label.text = TranslationServer.translate("Music")+":"
		sound_label.text = TranslationServer.translate("Sound")+":"
	elif event.is_action_pressed(&"Music_left"):
		if GlobalSapphire.music_level > 0:
			settings_node.change_music_level(-1)
	elif event.is_action_pressed(&"Music_right"):
		if GlobalSapphire.music_level < 15:
			settings_node.change_music_level(1)
	elif event.is_action_pressed(&"Sound_left"):
		if GlobalSapphire.sound_level > 0:
			settings_node.change_sound_level(-1)
	elif event.is_action_pressed(&"Sound_right"):
		if GlobalSapphire.sound_level < 15:
			settings_node.change_sound_level(1)

func _on_back_pressed() -> void:
	settings_node.activate_option(BACK)

func _on_check_box_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		settings_node.activate_music()
	else:
		settings_node.stop_music()
