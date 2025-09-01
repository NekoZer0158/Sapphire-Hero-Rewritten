class_name Level_Final
extends Level

@onready var audio_stream_player_explosion = $AudioStreamPlayer_explosion

var achievement_sprite := preload("res://Sprites/UI/Achievements/Black_baron_achievement.png")

var can_get_achievement : bool = true
var start_checking_achievement : bool = false

func _on_camera_borders_change_4_player_entered():
	if is_instance_valid(GlobalSapphire.player):
		if is_instance_valid(GlobalSapphire.player.player_body):
			GlobalSapphire.player.player_camera.position_smoothing_enabled = false

func _on_explosive_platform_explosion_activated():
	audio_stream_player_explosion.play()

func _end_level() -> void:
	if can_get_achievement and not "Black_baron_achievement" in GlobalSapphire.achievements_data.unlocked_achievements:
		GlobalSapphire.get_this_achievement_and_save("Black_baron_achievement")
		GlobalSapphire.player.player_UI._got_achievement("Black_baron_achievement",achievement_sprite)
	super._end_level()

func _activated_boss() -> void:
	start_checking_achievement = true
	super._activated_boss()

func _player_got_hit(_hp:int) -> void:
	if start_checking_achievement:
		can_get_achievement = false

func spawn_player() -> void:
	var p = player.instantiate()
	p.player_body.global_position = checkpoints[cur_checkpoint].player_pos.global_position/4
	p.please_restart_a_level.connect(_restart_a_level)
	add_child(p)
	if !not_epilogue:
		p.epilogue = true
	if cur_checkpoint == 0:
		for i in GlobalSapphire.player_savedata.player_hp_refills.keys():
			p.player_body.hp_refills += GlobalSapphire.player_savedata.player_hp_refills[i]
		p.player_UI._on_player_body_hp_refill_change(p.player_body.hp_refills)
	else:
		p.player_body.hp_refills = GlobalSapphire.cur_hp_refills
		p.player_UI._on_player_body_hp_refill_change(GlobalSapphire.cur_hp_refills)
	if GlobalSapphire.cur_ammo.size() > 0:
		p.player_body.ammo = GlobalSapphire.cur_ammo.duplicate(true)
	p.player_UI.pause_UI.restart_a_level.connect(_restart_a_level)
	p.player_UI.pause_UI.please_back_to_menu.connect(_back_to_menu)
	p.player_body.got_hit.connect(_player_got_hit)
	for i in achievements:
		i.got_achievement.connect(p.player_UI._got_achievement)
	p.player_camera.reset_smoothing()
