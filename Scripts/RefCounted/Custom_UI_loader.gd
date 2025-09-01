class_name Custom_UI_loader
extends RefCounted

static func load_progress_bar(progress_bar_texture:Texture2D,number:int,append_this_name:String,name:String) -> CS_single:
	var new_progress_bar : CS_single = load("res://Scenes/UI/Customization/Customization_progress_bar.tscn").instantiate()
	new_progress_bar.names.append(append_this_name)
	new_progress_bar.folder_name = name+str(number)
	new_progress_bar.text.append(name+str(number))
	new_progress_bar.load_texture = false
	new_progress_bar.custom_texture = progress_bar_texture
	return new_progress_bar

static func load_weapon_slot(weapon_slot_textures:Array[Texture2D],number:int,append_this_names:Array[String],name:String) -> CS_single:
	var new_weapon_slot : CS_single = load("res://Scenes/UI/Customization/CS_weapon.tscn").instantiate()
	new_weapon_slot.names.append(append_this_names[0])
	new_weapon_slot.names.append(append_this_names[1])
	new_weapon_slot.folder_name = name+str(number)
	new_weapon_slot.text.append(name+str(number))
	new_weapon_slot.load_texture = false
	new_weapon_slot.custom_texture = weapon_slot_textures[0]
	new_weapon_slot.second_custom_texutre = weapon_slot_textures[1]
	return new_weapon_slot
