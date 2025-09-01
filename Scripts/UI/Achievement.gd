class_name Achievement
extends Node2D

@export_color_no_alpha var active_color : Color
@export var Name : String = "Test"
@export var Desc : String

@onready var color_border: NinePatchRect = $Color_border
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var background: NinePatchRect = $Background
@onready var achievement_name: Label = $Achievement_name
@onready var unlocked: Sprite2D = $Unlocked
@onready var button_mobile: Button = $Button_mobile

var color : Color

func _ready() -> void:
	$Color_border2.queue_free()
	if OS.has_feature("mobile"):
		button_mobile.show()
	else:
		button_mobile.queue_free()
	set_everything()

func set_everything(load_texture:bool=true) -> void:
	color = active_color
	if load_texture:
		sprite_2d.texture = load("res://Sprites/UI/Achievements/"+Name+".png")
	achievement_name.text = Name
	background.self_modulate = color*0.35

func set_texture_for_sprite(texture:Texture) -> void:
	sprite_2d.texture = texture

func deactivate() -> void:
	background.self_modulate = active_color*0.35
	color_border.self_modulate = Color.WHITE

func activate() -> void:
	background.self_modulate = active_color*0.65
	color_border.self_modulate = active_color

func unlock_achievement() -> void:
	unlocked.show()
