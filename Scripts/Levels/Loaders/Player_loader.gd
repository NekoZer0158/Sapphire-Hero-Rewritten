extends Node

func spawn_player(level : Node,cur_checkpoint:int) -> void:
	var player_marker : Marker2D = level.get_node("Checkpoints").get_child(cur_checkpoint)
	var player : Player
	if level.upgraded_player:
		player = load("res://Scenes/Player/Player_improved.tscn").instantiate()
	else:
		player = load("res://Scenes/Player/Player.tscn").instantiate()
	player.player_body.global_position = player_marker.global_position/4
	player.please_restart_a_level.connect(level._restart_a_level)
	player.player_UI.pause_UI.restart_a_level.connect(level._restart_a_level)
	player.player_UI.pause_UI.please_back_to_menu.connect(level._back_to_menu)
	player.player_body.hp_refills = GlobalSapphire.cur_hp_refills
	player.player_UI._on_player_body_hp_refill_change(GlobalSapphire.cur_hp_refills)
	if level.sliding:
		player.player_body.sliding = true
	level.add_child(player)
	if "player_weapons" in level:
		if (level.player_weapons & 1<<0) > 0: # Kostyanoy
			player.add_new_weapon("Double_scythe")
			player.player_UI.amount_of_weapons += 1
		if (level.player_weapons & 1<<1) > 0: # Ledyanoy
			player.add_new_weapon("Power_punch")
			player.player_UI.amount_of_weapons += 1
		if (level.player_weapons & 1<<2) > 0: # Unknown
			player.add_new_weapon("Triple_weapon")
			player.player_UI.amount_of_weapons += 1
		if (level.player_weapons & 1<<3) > 0: # Zeppelin
			player.add_new_weapon("Zeppelin_weapon")
			player.player_UI.amount_of_weapons += 1
		player.player_UI.weapons.text = str(player.player_UI.amount_of_weapons)
