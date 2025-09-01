class_name Camera_borders_change
extends Node2D

@onready var top_marker2d : Marker2D = $Top
@onready var bottom_marker2d : Marker2D = $Bottom
@export var set_default_limits : bool = false
@export var set_limit_left : bool = true
@export var reset_smoothing : bool = true
@export var use_only_if_x_less_than_number : bool = false
@export var less_than_this_number : float
@export var default_limits : Vector3i = Vector3i(0,1080,0)
@export_group("Right Limit")
@export var set_right_limit : bool = false
@export var right_limit : int = 0
@export_group("Block_door")
@export var block_this_door : Door

signal activate_something()
signal player_entered()

func change_camera(player_camera:Camera2D) -> void:
	if is_instance_valid(block_this_door):
		block_this_door.can_door_open = false
	if !set_default_limits:
		if player_camera.limit_top != int(top_marker2d.global_position.y):
			if set_limit_left:
				player_camera.limit_left = int(top_marker2d.global_position.x)
			player_camera.limit_top = int(top_marker2d.global_position.y)
			player_camera.limit_bottom = int(bottom_marker2d.global_position.y)
			if set_right_limit:
				player_camera.limit_right = right_limit
			if reset_smoothing:
				player_camera.call_deferred("reset_smoothing")
	else:
		if set_limit_left:
			player_camera.limit_left = default_limits.z
		player_camera.limit_top = default_limits.x
		player_camera.limit_bottom = default_limits.y
		if set_right_limit:
			player_camera.limit_right = right_limit
		if reset_smoothing:
			player_camera.call_deferred("reset_smoothing")
	emit_signal("activate_something")

func _on_area_2d_body_entered(body):
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			if (!use_only_if_x_less_than_number) or (use_only_if_x_less_than_number and body.global_position.x/4 < less_than_this_number):
				emit_signal("player_entered")
				change_camera(body.get_parent().player_camera)
