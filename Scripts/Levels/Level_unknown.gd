extends Level

@export var enter_doors : Array[Door]

@onready var moon: Sprite2D = $Sky/Moon/Moon

var achievement_sprite := preload("res://Sprites/UI/Achievements/Moon_achievement.png")

func start() -> void:
	if Time.get_time_dict_from_system()["hour"] >= 0 and Time.get_time_dict_from_system()["hour"] <= 5:
		moon.frame = 1
		if not "Moon_achievement" in GlobalSapphire.achievements_data.unlocked_achievements:
			GlobalSapphire.get_this_achievement_and_save("Moon_achievement")
			GlobalSapphire.player.player_UI._got_achievement("Moon_achievement",achievement_sprite)

func _on_enter_area_body_entered(body):
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			for i in enter_doors:
				i.can_door_open = false
