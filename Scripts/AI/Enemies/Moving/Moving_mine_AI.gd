@icon("res://Sprites/Icons/Moving_mine.svg")
class_name Moving_mine_AI
extends Node2D

@onready var enemy_body : Moving_mine = $Moving_mine
@onready var raycast_left : RayCast2D = $Moving_mine/RayCast_left
@onready var raycast_right : RayCast2D = $Moving_mine/RayCast_right
@onready var raycast_move_left : RayCast2D = $Moving_mine/Move_left
@onready var raycast_move_right : RayCast2D = $Moving_mine/Move_right
@onready var check_ground_left = $Moving_mine/Check_ground_left
@onready var check_ground_right = $Moving_mine/Check_ground_right

var cur_target : Moving_body

const distance : float = 550.0

func _ready():
	enemy_body.type = GlobalEnum.BodyTypes.ENEMY

func _physics_process(_delta):
	if raycast_left.get_collider() != null:
		if check_collider(raycast_left.get_collider()):
			cur_target = raycast_left.get_collider()
	if raycast_right.get_collider() != null:
		if check_collider(raycast_right.get_collider()):
			cur_target = raycast_right.get_collider()
	if enemy_body.activated:
		if is_instance_valid(cur_target):
			if abs(cur_target.global_position.x-enemy_body.global_position.x) > distance:
				if cur_target.global_position.x > enemy_body.global_position.x:
					if check_collider_can_move(raycast_move_left.get_collider()) and check_collider_ground(check_ground_left.get_collider()):
						enemy_body.movement(1.0)
					else:
						enemy_body.movement(0.0)
				else:
					if check_collider_can_move(raycast_move_right.get_collider()) and check_collider_ground(check_ground_right.get_collider()):
						enemy_body.movement(-1.0)
					else:
						enemy_body.movement(0.0)
			else:
				enemy_body.movement(0.0)
				enemy_body.shoot()
		else:
			enemy_body.movement(0.0)

func check_collider(cur_collider) -> bool:
	if cur_collider is Moving_body:
		if cur_collider.type != enemy_body.type and not cur_collider in GlobalSapphire.type_friendlists[enemy_body.type]:
			return true
	return false

func check_collider_can_move(cur_collider) -> bool:
	if cur_collider is TileMapLayer:
		return false
	return true

func check_collider_ground(cur_collider) -> bool:
	if cur_collider != null:
		return true
	return false
