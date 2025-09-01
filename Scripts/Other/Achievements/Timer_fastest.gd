extends Timer

var sprite := preload("res://Sprites/UI/Achievements/Fastest.png")
var seconds : int = 0

@onready var level_base: Level = $".."

func _on_timeout() -> void:
	if level_base.cur_checkpoint == 0:
		seconds += 1
	else:
		seconds = 999
		stop()

func _on_zeppelin_end_level() -> void:
	stop()
	if level_base.cur_checkpoint == 0:
		if seconds <= 100 and check_levels() and not "Fastest" in GlobalSapphire.achievements_data.unlocked_achievements:
			GlobalSapphire.get_this_achievement_and_save("Fastest")
			GlobalSapphire.player.player_UI._got_achievement("Fastest",sprite)

func check_levels() -> bool:
	var levels : int = 0 
	for i in GlobalSapphire.player_savedata.completed_levels.keys():
		levels += GlobalSapphire.player_savedata.completed_levels[i]
	if levels < 4:
		return true
	return false
