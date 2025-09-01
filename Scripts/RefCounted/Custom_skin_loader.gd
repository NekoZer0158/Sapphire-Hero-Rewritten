class_name Custom_skin_loader
extends RefCounted

static func load_head(head_texture:Texture2D,number:int,append_this_name:String,name:String,use_shader:bool) -> CS_single:
	var new_cs_single_for_head : CS_single = load("res://Scenes/UI/Customization/Customization_single.tscn").instantiate()
	set_default_stuff_for_customization_slot(new_cs_single_for_head,number,name,use_shader)
	new_cs_single_for_head.names.append(append_this_name)
	new_cs_single_for_head.load_texture = false
	new_cs_single_for_head.custom_texture = head_texture
	return new_cs_single_for_head

static func set_default_stuff_for_customization_slot(custom_slot:Customization_select,number:int,name:String,use_shader:bool) -> void:
	if use_shader:
		custom_slot.use_this_shader = load("res://Resources/ShaderMaterials/Customization_UI.tres")
	custom_slot.folder_name = name+str(number)
	custom_slot.text.append(name+str(number))
