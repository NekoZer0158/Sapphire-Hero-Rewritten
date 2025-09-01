class_name Mod_interface_level
extends Mod_interface

signal start_this_level(level_path:String)

func activate(_save:bool=true) -> void:
	start_this_level.emit(main_scene_path)

func deactivate() -> void:
	pass
