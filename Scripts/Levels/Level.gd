@icon("res://Sprites/Icons/Level.svg")
class_name Level
extends Node2D

@export var level_name : String = "No_name"
@export var boss_name : String = "No_name"
@export var level_path : String = "" ## the path that leads to this level
@export var cur_checkpoint : int = 0
@export var level_music : AudioStream
@export var boss_music : AudioStream
@export var not_epilogue : bool = true
@export var achievements : Array[Achievement_checker]
@export var boss_checkpoint : int ## this should be the last checkpoint before the boss
@export var sliding : bool = false ## for snow level

var got_hp_refill : bool = false
var checkpoints : Dictionary
var level_selection_scene := preload("res://Scenes/Levels/Level_selection.tscn")

@export var player = preload("res://Scenes/Player/Player.tscn")

func _ready():
	if not_epilogue:
		if GlobalSapphire.player_savedata != null:
			if GlobalSapphire.player_savedata.completed_levels["Black_Baron"] == 1:
				player = load("res://Scenes/Player/Player_improved.tscn")
	else:
		GlobalSapphire.player_savedata = Savedata.new()
		GlobalSapphire.player_savedata.completed_levels["Unknown"] = 1
		GlobalSapphire.player_savedata.completed_levels["Kostyanoy"] = 1
		GlobalSapphire.player_savedata.completed_levels["Ledyanoy"] = 1
		GlobalSapphire.player_savedata.completed_levels["Zeppelin"] = 1
		player = load("res://Scenes/Player/Player_improved.tscn")
	GlobalSapphire.when_spawning_new_level()
	if scale.x != 4:
		scale.x = 4
		scale.y = 4
	check_checkpoints()
	start()
	if OS.has_feature("standalone"):
		Custom_music_loader.new().load_custom_music(self)
		load_ready_mods()
	if level_music != null and cur_checkpoint == 0 and GlobalSapphire.current_music == null:
		GlobalSapphire.play_music(level_music)
	elif GlobalSapphire.music_player != null:
		GlobalSapphire.music_player.stream_paused = false

func check_checkpoints():
	var checkpoints_array : Array[Node] = $Checkpoints.get_children()
	for i in checkpoints_array:
		if i is Checkpoint:
			checkpoints[i.cur_checkpoint] = i
		else:
			push_error("This is not a checkpoint")
	if cur_checkpoint in checkpoints.keys():
		spawn_player()
	else:
		push_error("This checkpoint doesn't exists")

func load_ready_mods() -> void:
	for i in GlobalMods.activated_mods:
		add_child(load(i).instantiate())

func start() -> void:
	pass

func spawn_player() -> void:
	var p = player.instantiate()
	p.player_body.global_position = checkpoints[cur_checkpoint].player_pos.global_position/4
	p.please_restart_a_level.connect(_restart_a_level)
	add_child(p)
	if !not_epilogue:
		p.epilogue = true
	if GlobalSapphire.player_savedata != null:
		if cur_checkpoint == 0:
			for i in GlobalSapphire.player_savedata.player_hp_refills.keys():
				p.player_body.hp_refills += GlobalSapphire.player_savedata.player_hp_refills[i]
			p.player_UI._on_player_body_hp_refill_change(p.player_body.hp_refills)
		else:
			p.player_body.hp_refills = GlobalSapphire.cur_hp_refills
			p.player_UI._on_player_body_hp_refill_change(GlobalSapphire.cur_hp_refills)
	if GlobalSapphire.cur_ammo.size() > 0 and !p.ammo_regeneration:
		p.player_body.ammo = GlobalSapphire.cur_ammo.duplicate(true)
	p.player_UI.pause_UI.restart_a_level.connect(_restart_a_level)
	p.player_UI.pause_UI.please_back_to_menu.connect(_back_to_menu)
	if sliding:
		p.player_body.sliding = true
		p.player_body.start()
		for i in get_tree().get_nodes_in_group("Enemy_soldier"):
			i.sliding = true
			i.start()
	for i in achievements:
		i.got_achievement.connect(p.player_UI._got_achievement)
	p.player_camera.reset_smoothing()

func _end_level() -> void:
	if is_instance_valid(GlobalSapphire.player):
		if is_instance_valid(GlobalSapphire.player.player_body):
			GlobalSapphire.player.player_body.immortal = true
	await GlobalSapphire.player.use_teleport_transition(1,4.5)
	if not_epilogue:
		GlobalSapphire.player_savedata.completed_levels[boss_name] = 1
		if got_hp_refill:
			GlobalSapphire.player_savedata.player_hp_refills[boss_name] = 1
		GlobalSapphire.save_data()
	GlobalSapphire.remove_music()
	_back_to_menu()

func _back_to_menu() -> void:
	GlobalSapphire.stop_music()
	GlobalSapphire.remove_music()
	var level_selection = level_selection_scene.instantiate()
	level_selection.first_time = false
	for i in get_tree().get_nodes_in_group("Projectile"):
		i.queue_free()
	get_parent().add_child(level_selection)
	queue_free()

func _on_hp_refill_picked_up_hp():
	got_hp_refill = true

func _restart_a_level() -> void:
	if got_hp_refill and GlobalSapphire.cur_hp_refills > 0:
		GlobalSapphire.cur_hp_refills -= 1
	for i in get_tree().get_nodes_in_group("Projectile"):
		i.queue_free()
	var cur_level = load(level_path).instantiate()
	queue_free()
	cur_level.cur_checkpoint = GlobalSapphire.cur_checkpoint
	get_parent().add_child(cur_level)

func _activated_boss() -> void:
	if cur_checkpoint != boss_checkpoint:
		GlobalSapphire.stop_music()
		GlobalSapphire.remove_music()
		GlobalSapphire.play_music(boss_music)
