class_name Custom_music_loader
extends Resource

func load_custom_music(level_node:Level) -> void:
	var cur_directory := DirAccess.get_files_at(OS.get_executable_path().get_base_dir()+"/Mods/Music")
	var level_first_slice : String
	for i in cur_directory:
		level_first_slice = i.get_slice(".",0)
		if i.ends_with(".mp3"):
			if level_first_slice == level_node.level_name:
				level_node.level_music = load_mp3_music(i)
			elif (level_node is Level_Final and level_first_slice == "Final_boss_music") or (level_node is not Level_Final and level_first_slice == "Boss_music"):
				level_node.boss_music = load_mp3_music(i)
		elif i.ends_with(".ogg"):
			if level_first_slice == level_node.level_name:
				level_node.level_music = load_ogg_music(i)
			elif (level_node is Level_Final and level_first_slice == "Final_boss_music") or (level_node is not Level_Final and level_first_slice == "Boss_music"):
				level_node.boss_music = load_ogg_music(i)

func load_mp3_music(music_file_name:String) -> AudioStreamMP3:
	var new_music_file := FileAccess.open(OS.get_executable_path().get_base_dir()+"/Mods/Music/"+music_file_name,FileAccess.READ)
	var music_buffer := new_music_file.get_buffer(new_music_file.get_length())
	var new_audio_stream : AudioStreamMP3 = AudioStreamMP3.new()
	new_audio_stream.data = music_buffer
	new_music_file.close()
	return new_audio_stream

func load_ogg_music(music_file_name:String) -> AudioStreamOggVorbis:
	var new_music_file := FileAccess.open(OS.get_executable_path().get_base_dir()+"/Mods/Music/"+music_file_name,FileAccess.READ)
	var music_buffer := new_music_file.get_buffer(new_music_file.get_length())
	var new_audio_stream : AudioStreamOggVorbis
	new_audio_stream = AudioStreamOggVorbis.load_from_buffer(music_buffer)
	new_music_file.close()
	return new_audio_stream
