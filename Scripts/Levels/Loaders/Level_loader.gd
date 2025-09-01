class_name Level_loader
extends Node

## FOR MODS ONLY

@onready var transition := $Transition
@onready var enemy_loader: Node = $Enemy_loader
@onready var player_loader: Node = $Player_loader
@onready var boss_loader: Node = $Boss_loader

var level_was_once_loaded : bool = false
var cur_checkpoint : int = 0

const TRANSITION_TIME : float = 0.5

func _ready() -> void:
	if OS.has_feature("mobile") or OS.has_feature("web"):
		queue_free()

func load_level(level_path:String) -> void:
	GlobalSapphire.when_spawning_new_level()
	transition.show()
	var parent_node : Node = get_parent()
	var level : Node2D= load(level_path).instantiate()
	if !level_was_once_loaded:
		GlobalSapphire.cur_checkpoint = 0
		GlobalSapphire.cur_hp_refills = level.hp_refills
		cur_checkpoint = level.cur_checkpoint
		var new_tween = get_tree().create_tween()
		new_tween.tween_property(transition,"modulate",Color(0.0,0.0,0.0,1.0),TRANSITION_TIME)
		await new_tween.finished
	else:
		cur_checkpoint = GlobalSapphire.cur_checkpoint
	parent_node.get_parent().call_deferred("add_child",level)
	await get_tree().process_frame
	if level.scale.x != 4:
		level.scale = Vector2(4,4)
	parent_node.remove_child(self)
	level.add_child(self)
	level.global_sapphire = GlobalSapphire
	level.level_loader = self
	parent_node.queue_free()
	player_loader.spawn_player(level,cur_checkpoint)
	spawn_objects(level)
	spawn_checkpoints(level)
	enemy_loader.spawn_enemies(level)
	boss_loader.spawn_bosses(level)
	transition.hide()
	level_was_once_loaded = true
	if level.sliding:
		for i in get_tree().get_nodes_in_group("Enemy_soldier"):
			i.sliding = true
			i.start()
	for i in GlobalMods.activated_mods:
		add_child(load(i).instantiate())
	if level.level_music != null and level.cur_checkpoint == 0 and GlobalSapphire.current_music == null:
		GlobalSapphire.play_music(level.level_music)

func enable_transition_for_a_main_menu() -> void:
	transition.modulate.a = 1.0
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(transition,"modulate",Color(0.0,0.0,0.0,0.0),TRANSITION_TIME)
	await new_tween.finished

func spawn_checkpoints(level : Node) -> void:
	const CHECKPOINT = preload("res://Scenes/Objects/Checkpoints/Checkpoint.tscn")
	var checkpoints_node := level.get_node("Checkpoints")
	var checkpoints := checkpoints_node.get_children()
	checkpoints.remove_at(0)
	for i in range(0,checkpoints.size()):
		var new_checkpoint := CHECKPOINT.instantiate()
		new_checkpoint.global_position = (checkpoints[i].global_position/4)-Vector2(0,32)
		checkpoints_node.add_child(new_checkpoint)
		new_checkpoint.cur_checkpoint = i+1
		checkpoints[i].queue_free()

func spawn_objects(level:Node) -> void:
	spawn_doors(level)
	spawn_computers(level)
	spawn_teleports(level)

func spawn_computers(level:Node) -> void:
	var COMPUTER = preload("res://Scenes/Objects/Unique/Computer.tscn")
	var computers_node := level.get_node_or_null("Objects/Computers")
	if computers_node != null:
		var computers := computers_node.get_children()
		for i in computers:
			var new_computer : Computer= COMPUTER.instantiate()
			new_computer.global_position = i.global_position/4
			new_computer.mod_computer = true
			computers_node.add_child(new_computer)
			new_computer.enemy_positions = i.enemy_positions
			if i.open_this_door_id != 0:
				for j in level.get_node("Objects/Doors").get_children():
					if j is Door:
						if j.id == i.open_this_door_id:
							new_computer.open_this_door = j
							break
			new_computer.atk = i.atk

func spawn_doors(level:Node) -> void:
	const TEST_DOOR = preload("res://Scenes/Objects/Doors/Test_door.tscn")
	var doors_node := level.get_node_or_null("Objects/Doors")
	if doors_node != null:
		var doors := doors_node.get_children()
		for i in doors:
			var new_door : Door = TEST_DOOR.instantiate()
			new_door.global_position = i.global_position/4
			doors_node.add_child(new_door)
			new_door.id = i.id
			new_door.can_door_open = i.can_door_open
			if i.door_top_and_bottom_texture != null:
				doors_node.get_node("Door_up/Sprite").texture = i.door_top_and_bottom_texture
				doors_node.get_node("Door_down/Sprite").texture = i.door_top_and_bottom_texture
			if i.door_center_texture != null:
				doors_node.get_node("Door_up/Door_center").texture = i.door_center_texture
			i.queue_free()

func spawn_teleports(level:Node) -> void:
	const TELEPORT = preload("res://Scenes/Objects/Teleports/Teleport_test.tscn")
	var teleports_node := level.get_node_or_null("Objects/Teleports")
	if teleports_node != null:
		var teleports := teleports_node.get_children()
		var teleport_instances : Array[Teleport]
		for i in teleports:
			var new_teleport : Teleport = TELEPORT.instantiate()
			new_teleport.mod_teleport = true
			new_teleport.global_position = i.global_position/4
			new_teleport.id = i.id
			new_teleport.other_teleport_id = i.other_teleport_id
			teleports_node.add_child(new_teleport)
			for j in teleport_instances:
				if j.id == new_teleport.other_teleport_id:
					new_teleport.teleport_to_this_teleport = j
			teleport_instances.append(new_teleport)
			i.queue_free()
		if teleport_instances.size() > 0:
			for i in teleport_instances:
				for j in teleport_instances:
					if i.id == j.other_teleport_id:
						j.teleport_to_this_teleport = i
