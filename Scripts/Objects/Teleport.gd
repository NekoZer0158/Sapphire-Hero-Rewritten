@icon("res://Sprites/Icons/Teleport.svg")
class_name Teleport
extends Activate_object

@export var id : int
@export var teleport_to_this_teleport : Teleport
@export var cur_frame : int = 0

# Mods only
var other_teleport_id : int
var mod_teleport : bool = false

func _ready():
	$Sprite2D.frame = cur_frame
	if !is_instance_valid(teleport_to_this_teleport) and !mod_teleport:
		push_error("No teleport")

func activate(player:Moving_body) -> void:
	if is_instance_valid(teleport_to_this_teleport):
		if player.get_parent().can_teleport:
			player.get_parent().can_teleport = false
			await player.get_parent().use_teleport_transition(1.0)
			player.global_position = teleport_to_this_teleport.global_position
			await player.get_parent().use_teleport_transition(0.0)
			player.get_parent().player_camera.limit_smoothed = true
			player.get_parent().can_teleport = true
	else:
		push_error("No teleport")
