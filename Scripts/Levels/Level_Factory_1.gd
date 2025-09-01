extends Level

@export var explosion_markers : Array[Marker2D]
@export var explosion : PackedScene
@export var time_before_end : float

@onready var tile_map_fake := $TileMap_fake
@onready var timer_before_end := $Timer_before_end
@onready var unknown_cutscene_2 := $Unknown_cutscene2
@onready var audio_stream_player := $AudioStreamPlayer
@onready var tile_map_new := $TileMap_new

var epilogue_end := preload("res://Scenes/Story/Epilogue_end.tscn")

func _remove_fake_wall() -> void:
	GlobalSapphire.stop_music()
	spawn_explosion()
	unknown_cutscene_2.show_robot()
	if is_instance_valid(tile_map_fake):
		tile_map_fake.queue_free()

func spawn_explosion() -> void:
	var new_boom : Enemy_boom
	audio_stream_player.play()
	tile_map_new.show()
	if is_instance_valid(GlobalSapphire.player):
		if is_instance_valid(GlobalSapphire.player.player_body):
			GlobalSapphire.player.player_body.immortal = true
	for i in explosion_markers:
		new_boom = explosion.instantiate()
		i.add_child(new_boom)

func _on_core_end_level():
	timer_before_end.start(time_before_end)

func _end_level() -> void:
	GlobalSapphire.stop_music()
	GlobalSapphire.current_music = null
	await GlobalSapphire.player.use_teleport_transition(1,4.5)
	if is_instance_valid(GlobalSapphire.player):
		if is_instance_valid(GlobalSapphire.player.player_body):
			GlobalSapphire.player.player_body.immortal = true
	for i in get_tree().get_nodes_in_group("Projectile"):
		i.queue_free()
	if is_instance_valid(GlobalSapphire.player):
		GlobalSapphire.player.can_control_player = false
		GlobalSapphire.player.player_UI.hide()
		GlobalSapphire.player.player_camera.queue_free()
		await get_tree().create_timer(0.3).timeout
		GlobalSapphire.player.process_mode = Node.PROCESS_MODE_DISABLED
		GlobalSapphire.player.teleport_transition.hide()
	#epilogue_end_ui.layer = 66
	#epilogue_end_ui.show()
	var spawn_this = epilogue_end.instantiate()
	spawn_this.parent_node = self
	get_parent().add_child(spawn_this)

func use_transition() -> void:
	var main_menu = load("res://Scenes/UI/Main_menu.tscn")
	var spawn_main_menu = main_menu.instantiate()
	get_parent().add_child(spawn_main_menu)
	queue_free()

func _back_to_menu() -> void:
	GlobalSapphire.stop_music()
	GlobalSapphire.current_music = null
	var main_menu = load("res://Scenes/UI/Main_menu.tscn")
	var spawn_main_menu = main_menu.instantiate()
	for i in get_tree().get_nodes_in_group("Projectile"):
		i.queue_free()
	get_parent().add_child(spawn_main_menu)
	queue_free()
