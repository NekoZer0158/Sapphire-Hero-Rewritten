class_name CS_single
extends Customization_select

@export var custom_name : String
@export var use_this_shader : Material

var custom_texture : Texture2D
var load_texture : bool = true

func _ready():
	if OS.has_feature("mobile"):
		button_mobile.show()
	else:
		button_mobile.queue_free()
	if folder_name == "":
		push_error("There is no folder name")
		queue_free()
	if names.size() != 1:
		push_error("There is no names or too many of them")
		queue_free()
	if use_this_shader != null:
		sprite_texture.material = use_this_shader
	if load_texture:
		sprite_texture.texture = load(files_path+folder_name+"/"+names[0]+".png")
	else:
		sprite_texture.texture = custom_texture


func select(selection_color:Color) -> void:
	super .select(selection_color)
	if unlocked:
		if custom_name != "":
			GlobalSapphire.customization_data.customization_info[custom_name] = folder_name
		else:
			GlobalSapphire.customization_data.customization_info[names[0]] = folder_name
