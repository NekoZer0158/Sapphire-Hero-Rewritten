class_name Custom_textures_loader
extends RefCounted

static func load_textures_from_folder(folder_name_1:String,folder_name_2:String) -> Dictionary:
	var path := OS.get_executable_path().get_base_dir()+"/Mods/"+folder_name_1+"/"+folder_name_2
	var textures : Dictionary
	if DirAccess.dir_exists_absolute(path):
		var cur_directory_files := DirAccess.get_files_at(path)
		for i in cur_directory_files:
			textures[i.get_slice(".",0)] = load_one_texture(path,i)
	return textures

static func load_one_texture(path:String,file_name:String) -> ImageTexture:
	return ImageTexture.create_from_image(Image.load_from_file(path+"/"+file_name))
