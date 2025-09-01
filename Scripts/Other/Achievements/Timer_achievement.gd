extends Timer

var sprite := preload("res://Sprites/UI/Achievements/FASTER_FASTER_FASTER.png")

@onready var level_base: Level = $".."

var seconds : int = 0

func _on_timeout() -> void:
	if level_base.cur_checkpoint == 0:
		seconds += 1
	else:
		seconds = 999
		stop()

func _on_ledyanoy_end_level() -> void:
	stop()
	if level_base.cur_checkpoint == 0:
		if seconds <= 80 and not "FASTER_FASTER_FASTER" in GlobalSapphire.achievements_data.unlocked_achievements:
			GlobalSapphire.get_this_achievement_and_save("FASTER_FASTER_FASTER")
			GlobalSapphire.player.player_UI._got_achievement("FASTER_FASTER_FASTER",sprite)
