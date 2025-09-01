class_name Translation_loader
extends Resource

@export var check_this_folder : String = "res://Translations/"

var or_check_this_folder : String = "res://Translations/"
#var show_debug : bool = false

func activate() -> void:
	if check_translations():
		if !OS.has_feature("web") and !OS.has_feature("mobile"):
			load_translations()
		else:
			load_translations_web()

func check_translations() -> bool:
	if GlobalSapphire.cur_locales.size() == 0:
		return true
	return false

func load_translations_web() -> void:
	var cur_directory
	var new_translation : Translation
	cur_directory = DirAccess.get_files_at(or_check_this_folder)
	if GlobalSapphire.cur_locales.size() == 0:
		GlobalSapphire.cur_locales = ["ru","en","el","de","es","it"]
		GlobalSapphire.only_ui_locales = ["el","de","es","it"]
	for i in cur_directory:
		if i.ends_with(".translation"):
			new_translation = load("res://Translations/"+i)
			#show_debug = true
			TranslationServer.add_translation(new_translation)
	check_cur_locale()

func load_translations() -> void:
	var cur_directory
	var new_translation : Translation
	#var optimized_t : OptimizedTranslation
	var new_file
	var csv_line
	var cur_tr : int = 0
	var max_tr : int = 1
	var is_this_first_line : bool = true
	var first_line : Array = []
	var story_locales : Array = []
	var ui_locales : Array = []
	var csv : String
	if !OS.has_feature("standalone"):
		cur_directory = DirAccess.get_files_at(or_check_this_folder)
	else:
		cur_directory = DirAccess.get_files_at(OS.get_executable_path().get_base_dir()+"/"+check_this_folder)
	for i in cur_directory:
		if i.ends_with(".csv"):
			first_line.clear()
			cur_tr = 0
			max_tr = 1
			while cur_tr < max_tr:
				is_this_first_line = true
				new_translation = Translation.new()
				if first_line.size() > 0:
					new_translation.locale = first_line[cur_tr]
					if i == "Story.csv" or i == "Achievements.csv":
						if story_locales.find(first_line[cur_tr]) == -1:
							story_locales.append(first_line[cur_tr])
					elif i == "UI.csv":
						if ui_locales.find(first_line[cur_tr]) == -1:
							ui_locales.append(first_line[cur_tr])
				new_file = FileAccess.open(check_this_folder+i,FileAccess.READ)
				while !new_file.eof_reached():
					csv_line = new_file.get_csv_line()
					if first_line.size() == 0 and is_this_first_line:
						first_line = csv_line.duplicate()
						first_line.remove_at(0)
						max_tr = first_line.size()
						new_translation.locale = first_line[cur_tr]
						if i == "Story.csv" or i == "Achievements.csv":
							if story_locales.find(first_line[cur_tr]) == -1:
								story_locales.append(first_line[cur_tr])
						elif i == "UI.csv":
							if ui_locales.find(first_line[cur_tr]) == -1:
								ui_locales.append(first_line[cur_tr])
					elif !is_this_first_line:
						csv = csv_line[0]
						csv_line = csv_line.slice(1,csv_line.size())
						new_translation.add_message(csv,csv_line[cur_tr])
					is_this_first_line = false
				#optimized_t = OptimizedTranslation.new()
				#optimized_t.generate(new_translation)
				#optimized_t.locale = first_line[cur_tr]
				TranslationServer.add_translation(new_translation)
				cur_tr += 1
	for i in ui_locales:
		if not i in story_locales:
			GlobalSapphire.only_ui_locales.append(i)
		GlobalSapphire.cur_locales.append(i)
	check_cur_locale()

func check_cur_locale() -> void:
	var cur_locale : String
	if TranslationServer.get_locale().length() > 2:
		cur_locale = TranslationServer.get_locale().substr(0,2)
	else:
		cur_locale = TranslationServer.get_locale()
	if cur_locale in GlobalSapphire.cur_locales:
		GlobalSapphire.cur_locale_int = GlobalSapphire.cur_locales.find(cur_locale)
		TranslationServer.set_locale(cur_locale)
	else:
		GlobalSapphire.cur_locale_int = GlobalSapphire.cur_locales.find("en")
		TranslationServer.set_locale("en")
