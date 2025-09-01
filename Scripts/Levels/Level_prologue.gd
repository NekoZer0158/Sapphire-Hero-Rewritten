extends Level

@onready var prologue_end_ui: CanvasLayer = $Prologue_end

const PROLOGUE_END = preload("res://Scenes/Story/Prologue_end.tscn")

func _end_level() -> void:
	await GlobalSapphire.player.use_teleport_transition(1,4.5)
	if is_instance_valid(GlobalSapphire.player):
		if is_instance_valid(GlobalSapphire.player.player_body):
			GlobalSapphire.player.player_body.immortal = true
	for i in get_tree().get_nodes_in_group("Projectile"):
		i.queue_free()
	if is_instance_valid(GlobalSapphire.player):
		GlobalSapphire.player.can_control_player = false
	var spawn_this = PROLOGUE_END.instantiate()
	spawn_this.parent_node = self
	prologue_end_ui.add_child(spawn_this)

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

func _on_area_2d_level_end_body_entered(body: Node2D) -> void:
	if body is Robot_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			_end_level()

func _on_area_2d_stop_music_body_entered(body: Node2D) -> void:
	if body is Robot_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			GlobalSapphire.stop_music()
			GlobalSapphire.current_music = null
