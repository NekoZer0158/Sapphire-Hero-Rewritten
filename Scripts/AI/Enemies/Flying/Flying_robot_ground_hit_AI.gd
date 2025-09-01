extends Flying_robot_AI

var cur_direction_x : float = -1.0
var cur_direction_y: float = 1.0

var cur_target : Moving_body

@onready var raycast_right : RayCast2D = $Robot_body/RayCast2D_right
@onready var raycast_left : RayCast2D = $Robot_body/RayCast2D_left

func check_raycast_collider(raycast_collider) -> void:
	if raycast_collider is Moving_body:
		if raycast_collider.type != enemy_body.type and not raycast_collider.type in GlobalSapphire.type_friendlists[enemy_body.type]:
			cur_target = raycast_collider
			activate_enemy = true

func _physics_process(_delta):
	if is_instance_valid(raycast_left):
		check_raycast_collider(raycast_left.get_collider())
	if is_instance_valid(raycast_right):
		check_raycast_collider(raycast_right.get_collider())
	if activate_enemy and is_instance_valid(cur_target):
		if enemy_body.is_on_floor() or enemy_body.is_on_ceiling():
			if is_instance_valid(cur_target):
				if cur_target.global_position.x > enemy_body.global_position.x:
					cur_direction_x = 1.0
				else:
					cur_direction_x = -1.0
			cur_direction_y = -cur_direction_y
		if enemy_body.is_on_wall():
			cur_direction_x = -cur_direction_x
			if cur_target.global_position.y > enemy_body.global_position.y:
				cur_direction_y = 1.0
			else:
				cur_direction_y = -1.0
		enemy_body.movement(cur_direction_x,[cur_direction_y])

func _on_area_2d_body_entered(body):
	if body is Moving_body:
		if not body.type in GlobalSapphire.type_friendlists[GlobalEnum.BodyTypes.ENEMY] and body.type != enemy_body.type:
			activate_enemy = true
			cur_target = body

func _on_robot_body_now_dead():
	queue_free()
