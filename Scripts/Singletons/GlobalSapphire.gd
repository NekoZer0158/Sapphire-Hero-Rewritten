extends Node

# Databases
var projectiles_database : Projectiles_database = preload("res://Resources/Databases/Projectiles_database.tres")

# Player
var player : Player = null
var player_weapon_ids : Array[int]
var player_UI : Player_UI = null
var cur_checkpoint : int = 0
var player_savedata : Savedata
var customization_data : Customization_data
var cur_hp_refills : int = 0
var cur_ammo : Array[Vector2i]

var cur_boss : Boss_AI
var achievements_data : Achievements_data
var activated_mods : Array[String]

# Audio
var music_player : AudioStreamPlayer
var music_level : int = 12:
	set(value):
		music_player.volume_db = -60+value*4
		music_level = value
var sound_level : int = 12
var current_music : AudioStream
const min_audio_value : int = -60

var vsync : int = 1
var mobile_version : bool = false
var game_was_completed : int = 0
var cur_locale_int : int = 0
var cur_locales : Array[String] = []
var only_ui_locales : Array[String] = []
var type_friendlists = {GlobalEnum.BodyTypes.PLAYER:[GlobalEnum.BodyTypes.COMRADE],
GlobalEnum.BodyTypes.COMRADE:[GlobalEnum.BodyTypes.PLAYER],
GlobalEnum.BodyTypes.ENEMY:[]}

func _ready():
	add_to_group("GlobalSapphire")
	process_mode = Node.PROCESS_MODE_ALWAYS
	if OS.has_feature("mobile") or OS.has_feature("web"):
		ProjectSettings["application/run/max_fps"] = 60
	if OS.has_feature("mobile"):
		get_tree().set_quit_on_go_back(false)
	add_music_player()

func _input(event):
	if event.is_action_pressed("Window_change"):
		match DisplayServer.window_get_mode():
			DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			_:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func when_spawning_new_level() -> void:
	clear_databases()
	projectiles_database.add_projectiles()

func clear_databases() -> void:
	projectiles_database.clear()

func add_music_player() -> void:
	if !is_instance_valid(music_player):
		music_player = AudioStreamPlayer.new()
		music_player.volume_db = min_audio_value+music_level*4
		music_player.finished.connect(_replay_music)
		add_child(music_player)
	else:
		push_error("Music_player already exist")

func play_music(cur_music:AudioStream) -> void:
	if !music_player.playing:
		music_player.stop()
		current_music = cur_music.duplicate(true)
		music_player.stream = current_music
		music_player.play()

func continue_music() -> void:
	music_player.stream_paused = false

func stop_music() -> void:
	music_player.stream_paused = true

func remove_music() -> void:
	current_music = null
	music_player.stream = null
	music_player.stream_paused = false
	music_player.stop()

func save_data() -> void:
	var slot_path : String = "user://Slot_"+str(player_savedata.save_number)+".json"
	var save_file := FileAccess.open(slot_path,FileAccess.WRITE)
	var save_data_json := {
		"save_number":player_savedata.save_number,
		"completed_levels":player_savedata.completed_levels,
		"player_hp_refills":player_savedata.player_hp_refills,
		"other_data":player_savedata.other_data,
		"dimension":player_savedata.dimension
	}
	var json_string := JSON.stringify(save_data_json)
	save_file.store_line(json_string)
	save_file.close()

func save_achievements() -> void:
	var achievements_path : String = "user://Achievements.json"
	var achievements_file := FileAccess.open(achievements_path,FileAccess.WRITE)
	var achievements_data_json := {
		"unlocked_achievements":achievements_data.unlocked_achievements.duplicate(true)
	}
	var json_string := JSON.stringify(achievements_data_json)
	achievements_file.store_line(json_string)
	achievements_file.close()

func _replay_music() -> void:
	music_player.play()

func get_this_achievement_and_save(achievement:String) -> void:
	if not achievement in achievements_data.unlocked_achievements:
		achievements_data.unlocked_achievements.append(achievement)
		save_achievements()

func get_game_info() -> Dictionary:
	var config := ConfigFile.new()
	config.load("res://export_presets.cfg")
	var game_info : Dictionary = {
		"name":"Sapphire Hero Rewritten",
		"part":1,
		"version":config.get_value("preset.0.options","application/file_version"),
		"minigame":"planes",
	}
	return game_info
