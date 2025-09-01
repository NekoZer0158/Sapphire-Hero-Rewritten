class_name Moving_platform
extends CharacterBody2D

@export var speed : Vector2 = Vector2(0,6000)
@export var check_wall : bool = false
@export var check_floor : bool = false
@export var change_camera : bool = false
@export var raycast_floor : RayCast2D
@export var raycast_wall : RayCast2D

var activated : bool = false

signal platform_started_moving()

func _ready():
	if check_floor and !is_instance_valid(raycast_floor):
		push_error("no raycast_floor")
	if check_wall and !is_instance_valid(raycast_wall):
		push_error("no raycast_wall")

func _physics_process(delta):
	if activated:
		velocity = speed*delta
		if check_wall:
			if raycast_wall.get_collider() != null:
				activated = false
		elif check_floor:
			if raycast_floor.get_collider() != null:
				activated = false
		move_and_slide()
	else:
		velocity = Vector2(0,0)

func _on_lever_activation():
	activated = true
	emit_signal("platform_started_moving")
	if change_camera:
		if is_instance_valid(GlobalSapphire.player):
			GlobalSapphire.player.player_camera.limit_left = int(global_position.x-(1920.0/2.0))
			GlobalSapphire.player.player_camera.limit_right = int(global_position.x+(1920.0/2.0))
			GlobalSapphire.player.player_camera.limit_bottom = 1080*10
			GlobalSapphire.player.player_camera.limit_smoothed = false
