@icon("res://Sprites/Icons/Flying_robot_drill.svg")
class_name Flying_robot_drill_AI
extends Flying_robot_AI

@onready var raycast_up : RayCast2D = $Robot_body/Up
@onready var raycast_down : RayCast2D = $Robot_body/Down

var cur_direction : float = 1.0
var cur_target : Moving_body

func start():
	if enemy_body.is_on_ceiling():
		cur_direction = 1.0
	elif enemy_body.is_on_floor():
		cur_direction = -1.0

func _physics_process(_delta):
	check_body(raycast_up.get_collider(),-1.0)
	check_body(raycast_down.get_collider(),1.0)
	if activate_enemy:
		enemy_body.movement(0.0,[cur_direction])
		if (enemy_body.is_on_floor() and cur_direction == 1.0) or (enemy_body.is_on_ceiling() and cur_direction == -1.0):
			enemy_body.movement(0.0,[0.0])
			activate_enemy = false

func check_body(body,direction:float) -> bool:
	if body != null:
		if body is Moving_body and !activate_enemy:
			if not body.type in GlobalSapphire.type_friendlists[GlobalEnum.BodyTypes.ENEMY] and body.type != enemy_body.type:
				cur_direction = direction
				activate_enemy = true
				return true
	return false


func _on_robot_body_now_dead():
	queue_free()
