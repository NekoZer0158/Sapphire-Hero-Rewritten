class_name Customization_select
extends Control

@export var names : Array[String]
@export var folder_name : String
@export var text : Array[String]
@export var files_path : String
@export_group("Unlock")
@export var unlocked : bool = true
@export var how_to_unlock_text : String

@onready var border : Sprite2D = $Border
@onready var background : Sprite2D = $Background
@onready var sprite_texture : Sprite2D = $Sprite_texture
@onready var button_mobile: Button = $Button_mobile

func _ready():
	push_error("Don't use this class, use subclasses")

func select(selection_color:Color) -> void:
	border.self_modulate = selection_color

func unselect() -> void:
	border.self_modulate = Color.WHITE
