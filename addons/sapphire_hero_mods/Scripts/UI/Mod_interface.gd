class_name Mod_interface
extends Control

@export var texture_rect_activation: TextureRect
@onready var icon: TextureRect = $Icon
@onready var name_richtextlabel: RichTextLabel = $Name
@onready var description_richtextlabel: RichTextLabel = $Description

var main_scene_path : String
var activated : bool = false
var color : Color = Color("418bd1")

func _ready() -> void:
	name_richtextlabel.self_modulate = color

func activate(save:bool=true) -> void:
	if !activated:
		activated = true
		if is_instance_valid(texture_rect_activation):
			texture_rect_activation.self_modulate = color
		if save:
			GlobalMods.activated_mods.append(main_scene_path)
			GlobalMods.save_activated_mods()
	else:
		deactivate()

func deactivate() -> void:
	activated = false
	if is_instance_valid(texture_rect_activation):
		texture_rect_activation.self_modulate = Color.BLACK
	if main_scene_path in GlobalMods.activated_mods:
		GlobalMods.activated_mods.erase(main_scene_path)
		GlobalMods.save_activated_mods()

func set_everything(new_icon:Texture2D,new_desc:String,new_main_scene_path:String) -> void:
	var name_and_desc := new_desc.split("\n",true,1)
	icon.texture = new_icon
	if name_and_desc.size() == 2:
		name_richtextlabel.text = name_and_desc[0]
		description_richtextlabel.text = name_and_desc[1]
	else:
		description_richtextlabel.text = name_and_desc[0]
	main_scene_path = new_main_scene_path
