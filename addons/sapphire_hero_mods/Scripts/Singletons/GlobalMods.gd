extends Node

var dont_save_activated_mods : bool = false

var mods_were_loaded : bool = false
var activated_mods : Array = []

func _ready() -> void:
	load_activated_mods()

func save_activated_mods() -> void:
	if !dont_save_activated_mods:
		var mods_path : String = "user://Mods.json"
		var file := FileAccess.open(mods_path,FileAccess.WRITE)
		var mods_data := {"Activated_mods":activated_mods}
		var json_string := JSON.stringify(mods_data)
		file.store_line(json_string)
		file.close()

func load_activated_mods() -> void:
	var mods_path : String = "user://Mods.json"
	var file := FileAccess.open(mods_path,FileAccess.READ)
	var json_string : String
	var json_data
	if file != null:
		json_string = file.get_line()
		file.close()
		json_data = JSON.parse_string(json_string)
		if json_data.size() > 0:
			activated_mods = json_data["Activated_mods"].duplicate(true)
