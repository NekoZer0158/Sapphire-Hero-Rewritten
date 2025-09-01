class_name Boss_UI
extends Control

@export var boss_HP_color : Color
@export var boss_body : Robot_body
@export var progress_bar_boss : ProgressBar
@export var use_boss_UI : bool = true

@onready var foreground = $X4/ProgressBar_HP_boss/Foreground

func _ready():
	foreground = load("res://Sprites/UI/Player/"+GlobalSapphire.customization_data.customization_info["Progress_bar"]+"/Progress_bar_real.png")
	if use_boss_UI:
		set_boss_hp(boss_body.hp,boss_HP_color)

func set_boss_hp(new_boss_hp:int,boss_hp_color:Color=Color.BLACK) -> void:
	progress_bar_boss.value = new_boss_hp
	if boss_hp_color != Color.BLACK:
		progress_bar_boss.modulate = boss_hp_color

func _on_boss_body_got_hit(new_hp):
	if use_boss_UI:
		progress_bar_boss.value = new_hp
