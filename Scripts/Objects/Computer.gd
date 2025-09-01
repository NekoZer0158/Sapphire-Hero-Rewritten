@icon("res://Sprites/Icons/Computer.svg")
class_name Computer
extends Activate_object

@export var enemy_positions : Array[int] = []
@export var open_this_door : Door
@export var atk : int = 0
@onready var sprite_2d = $Sprite2D

var mod_computer : bool = false
var cur_body : Moving_body
var planes_minigame = preload("res://Scenes/Minigames/Hack_planes/Screen.tscn")
var minigame
var activated : bool = false
var minigame_completed : bool = false

func _ready():
	if !is_instance_valid(open_this_door) and !mod_computer:
		push_error("There is no door")

func activate(player:Moving_body) -> void:
	var player_parent = player.get_parent()
	if GlobalSapphire.mobile_version:
		for i in get_tree().get_nodes_in_group("mobile_disable_for_plane_minigame"):
			i.hide()
		for i in get_tree().get_nodes_in_group("mobile_controls_for_plane_minigame"):
			i.show()
	if !minigame_completed:
		if !activated:
			if !is_instance_valid(minigame):
				minigame = planes_minigame.instantiate()
				minigame.enemy_positions = enemy_positions
				player_parent.can_control_player = false
				activated = true
				minigame.now_minigame_ended.connect(_end_minigame)
				minigame.minigame_failed.connect(_failed_minigame)
				get_parent().add_child(minigame)
			else:
				activated = true
				player_parent.can_control_player = false
				minigame.show()
				minigame.process_mode = PROCESS_MODE_PAUSABLE
		else:
			if is_instance_valid(minigame):
				activated = false
				player_parent.can_control_player = true
				minigame.hide()
				minigame.process_mode = PROCESS_MODE_DISABLED

func _end_minigame() -> void:
	minigame_completed = true
	cur_body.get_parent().disable_activation()
	sprite_2d.frame = 1
	open_this_door.can_door_open = true
	hide_and_show_needed_nodes()
	for i in get_tree().get_nodes_in_group("activate_button_mobile"):
		i.hide()
	GlobalSapphire.player.can_control_player = true
	minigame.queue_free()

func hide_and_show_needed_nodes() -> void:
	if GlobalSapphire.mobile_version:
		for i in get_tree().get_nodes_in_group("mobile_disable_for_plane_minigame"):
			i.show()
		for i in get_tree().get_nodes_in_group("mobile_controls_for_plane_minigame"):
			i.show()
		for i in get_tree().get_nodes_in_group("minigame_only"):
			i.hide()

func _failed_minigame() -> void:
	minigame.queue_free()
	activated = false
	hide_and_show_needed_nodes()
	GlobalSapphire.player.player_body.hit(atk)
	GlobalSapphire.player.can_control_player = true

func _on_enter_area_body_entered(body):
	if !minigame_completed:
		if body is Moving_body:
			if body.type == GlobalEnum.BodyTypes.PLAYER:
				body.get_parent().enable_activation(self)
				cur_body = body
