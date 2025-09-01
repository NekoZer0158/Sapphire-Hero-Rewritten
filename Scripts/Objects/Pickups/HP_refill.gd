class_name HP_refill
extends Pickup

@export var boss_name : String = "No_name" ## Boss name should be the same as in the level.

@onready var sprite_2d = $Sprite2D

var hp_refills_master_sprite := preload("res://Sprites/UI/Achievements/HP_refills_master.png")

signal picked_up_hp()

func _ready():
	const MODS_UI_NAMES : Array[String] = ["UI_1","UI_2","UI_3"]
	if not GlobalSapphire.customization_data.customization_info["HP_refill"] in MODS_UI_NAMES:
		sprite_2d.texture = load("res://Sprites/UI/Player/"+GlobalSapphire.customization_data.customization_info["HP_refill"]+"/HP_refill.png")
	else:
		sprite_2d.texture = Custom_textures_loader.load_one_texture(OS.get_executable_path().get_base_dir()+"/Mods/UI/",GlobalSapphire.customization_data.customization_info["HP_refill"]+"/HP_refill.png")
	await get_tree().create_timer(3,false).timeout
	if boss_name in GlobalSapphire.player_savedata.player_hp_refills.keys():
		if GlobalSapphire.player_savedata.player_hp_refills[boss_name] == 1:
			queue_free()
	if check_hp_refills() == 5 and not "HP_refills_master" in GlobalSapphire.achievements_data.unlocked_achievements:
		get_achievement()

func use_pickup(body:Robot_body) -> void:
	body.hp_refills += 1
	emit_signal("picked_up_hp")
	body.emit_signal("hp_refill_change",body.hp_refills)
	if (body.hp_refills == 5 or check_hp_refills() == 4) and not "HP_refills_master" in GlobalSapphire.achievements_data.unlocked_achievements:
		get_achievement()

func get_achievement() -> void:
	GlobalSapphire.get_this_achievement_and_save("HP_refills_master")
	GlobalSapphire.player.player_UI._got_achievement("HP_refills_master",hp_refills_master_sprite)

func check_hp_refills() -> int:
	var hp_refills : int = 0
	for i in GlobalSapphire.player_savedata.player_hp_refills.keys():
		hp_refills += GlobalSapphire.player_savedata.player_hp_refills[i]
	return hp_refills
