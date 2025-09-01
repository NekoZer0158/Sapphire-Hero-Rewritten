extends Achievement_checker

func start_achievement(args:Array) -> void:
	super .start_achievement(args)
	if args.size() == 2:
		if typeof(args[0]) == TYPE_INT:
			data_to_check["HP"] = args[0]
		if typeof(args[1]) == TYPE_INT:
			data_to_check["HP_refills"] = args[1]

func check_if_completed(args:Array) -> void:
	if args[0] == data_to_check["HP"] and args[1] == data_to_check["HP_refills"] and not "Elevator_no_damage" in GlobalSapphire.achievements_data.unlocked_achievements:
		GlobalSapphire.get_this_achievement_and_save(achievement_name)
		emit_signal("got_achievement",achievement_name,achievement_texture)
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Moving_body and !GlobalSapphire.player_savedata.other_data["Watched_cutscene_before_final_boss"]:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			start_achievement([body.hp,body.hp_refills])

func _on_area_2d_end_body_entered(body: Node2D) -> void:
	if body is Moving_body and !GlobalSapphire.player_savedata.other_data["Watched_cutscene_before_final_boss"]:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			check_if_completed([body.hp,body.hp_refills]) 
