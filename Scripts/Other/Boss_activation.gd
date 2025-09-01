class_name Boss_activation
extends Node2D

@export var boss : Boss_AI
@export var close_this_door : Door

func _ready():
	if !is_instance_valid(boss):
		push_error("There is no boss")
	if !is_instance_valid(close_this_door):
		push_error("There is no door")

func activate_boss(player_body:Player):
	if is_instance_valid(player_body):
		set_camera_limit(player_body.player_camera)
		if is_instance_valid(boss):
			boss.activate_boss()
		close_this_door.can_door_open = false
		queue_free()
	else:
		push_error("No player_body")

func _on_area_2d_body_entered(body):
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			activate_boss(body.get_parent())

func set_camera_limit(camera_node:Camera2D):
	if is_instance_valid(camera_node):
		camera_node.limit_left = int(global_position.x)
		camera_node.limit_right = int(global_position.x+1920)
		camera_node.limit_smoothed = false
	else:
		push_error("There is no camera_node")
