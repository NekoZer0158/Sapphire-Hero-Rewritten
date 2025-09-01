extends Node

func spawn_bosses(level : Node) -> void:
	var bosses_node := level.get_node_or_null("Bosses")
	if bosses_node != null:
		var bosses := bosses_node.get_children()
		var preloaded_bosses : Dictionary[String,PackedScene]
		for i in bosses:
			var boss : Boss_AI
			if i.name.begins_with("Kostyanoy"):
				if not "Kostyanoy" in preloaded_bosses.keys():
					preloaded_bosses["Kostyanoy"] = preload("res://Scenes/Boss/Kostyanoy.tscn")
				boss = preloaded_bosses["Kostyanoy"].instantiate()
				boss.scale = i.scale
				boss.rotation = i.rotation
				i.activation_zone.boss = boss
			boss.global_position = i.global_position/4
			bosses_node.add_child(boss)
			i.queue_free()
