class_name Player_UI
extends Control

@export var progress_bar_HP_color : Color = Color("477bff")
@export var progress_bar_HP : ProgressBar
@export var progress_bar_ammo : ProgressBar
@export var hp_refill_label : Label
@export var pause_UI : Pause_UI

@onready var weapons := $X4/Weapons
@onready var sprite_hp_reifll := $Nodes_2D/Sprite_HP_reifll
@onready var foreground_progress_bar_HP := $X4/ProgressBar_HP/Foreground
@onready var foreground_progress_bar_ammo := $X4/ProgressBar_ammo/Foreground
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var achievement: Achievement = $Achievement/Achievement

var amount_of_weapons : int = 0

func _ready():
	load_UI_textures()

func load_UI_textures() -> void:
	const MODS_SKINS_NAMES : Array[String] = ["UI_1","UI_2","UI_3"]
	var mods_skins_path := OS.get_executable_path().get_base_dir()+"/Mods/UI/"
	if not GlobalSapphire.customization_data.customization_info["HP_refill"] in MODS_SKINS_NAMES:
		sprite_hp_reifll.texture = load("res://Sprites/UI/Player/"+GlobalSapphire.customization_data.customization_info["HP_refill"]+"/HP_refill.png")
	else:
		sprite_hp_reifll.texture = Custom_textures_loader.load_one_texture(mods_skins_path+GlobalSapphire.customization_data.customization_info["HP_refill"],"HP_refill.png")
	if not GlobalSapphire.customization_data.customization_info["Progress_bar"] in MODS_SKINS_NAMES:
		foreground_progress_bar_HP.texture = load("res://Sprites/UI/Player/"+GlobalSapphire.customization_data.customization_info["Progress_bar"]+"/Progress_bar_real.png")
		foreground_progress_bar_ammo.texture = load("res://Sprites/UI/Player/"+GlobalSapphire.customization_data.customization_info["Progress_bar"]+"/Progress_bar_real.png")
	else:
		foreground_progress_bar_HP.texture = Custom_textures_loader.load_one_texture(mods_skins_path+GlobalSapphire.customization_data.customization_info["Progress_bar"],"Progress_bar_real.png")
		foreground_progress_bar_ammo.texture = Custom_textures_loader.load_one_texture(mods_skins_path+GlobalSapphire.customization_data.customization_info["Progress_bar"],"Progress_bar_real.png")

func set_everything(player:Player) -> void:
	_set_hp(player.player_body.hp)
	if GlobalSapphire.player_savedata != null:
		for i in GlobalSapphire.player_savedata.completed_levels.keys():
			if GlobalSapphire.player_savedata.completed_levels[i] == 1 and i != "Black_Baron":
				amount_of_weapons += 1
	weapons.text = str(amount_of_weapons)
	progress_bar_HP.self_modulate = progress_bar_HP_color
	_set_ammo(player.player_body.ammo[player.player_body.cur_weapon].x)

func _input(event):
	if event.is_action_pressed("Pause") and GlobalSapphire.player.can_control_player:
		pause_was_pressed()

func pause_was_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
		GlobalSapphire.continue_music()
		for i in get_tree().get_nodes_in_group("Player_controls_mobile"):
			i.show()
		if GlobalSapphire.player.can_activate and GlobalSapphire.mobile_version:
			var button_mobile_nods := get_tree().get_nodes_in_group("activate_button_mobile")
			if button_mobile_nods.size() > 0:
				button_mobile_nods[0].show()
		pause_UI.stop_music()
		pause_UI.settings.hide()
		pause_UI.usable = false
		pause_UI.hide()
	else:
		get_tree().paused = true
		GlobalSapphire.stop_music()
		if GlobalSapphire.mobile_version:
			for i in get_tree().get_nodes_in_group("M_hide_settings"):
				i.show()
		pause_UI.usable = true
		pause_UI.show()

func _set_hp(new_hp:int) -> void:
	progress_bar_HP.value = new_hp

func _set_ammo(new_ammo:int) -> void:
	if new_ammo >= 0:
		progress_bar_ammo.value = new_ammo
	else:
		progress_bar_ammo.value = 0

func _on_player_body_weapon_changed(new_weapon:Weapon,ammo_for_weapon:int) -> void:
	_set_ammo(ammo_for_weapon)
	if new_weapon is Weapon_with_colors:
		progress_bar_ammo.self_modulate = new_weapon.ammo_color

func _on_player_body_hp_refill_change(new_hp_refill) -> void:
	if is_instance_valid(hp_refill_label):
		hp_refill_label.text = "="+str(new_hp_refill)
	else:
		push_error("no hp_refill_label")

func _got_achievement(achievement_name:String,achievement_texture:Texture) -> void:
	achievement.Name = achievement_name
	achievement.set_everything(false)
	achievement.set_texture_for_sprite(achievement_texture)
	achievement.activate()
	animation_player.play("Show_achievement")
