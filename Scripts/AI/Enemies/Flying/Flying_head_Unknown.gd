extends Flying_robot_AI

@export var timer : Timer

@onready var ray_cast_2d: RayCast2D = $Robot_body/RayCast2D

var cur_target : Robot_body
var boss_body : Robot_body

var cur_direction : Vector2

func start():
	if is_instance_valid(timer):
		timer.start(enemy_body.reload_time+0.1)
	else:
		push_error("no timer")

func _physics_process(_delta):
	if is_instance_valid(cur_target) and is_instance_valid(boss_body):
		if cur_target.global_position > enemy_body.global_position and enemy_body.scale.y != 1:
			enemy_body.body_resources["Body_change_direction"].change_direction(1.0,enemy_body)
		elif cur_target.global_position < enemy_body.global_position and enemy_body.scale.y != -1:
			enemy_body.body_resources["Body_change_direction"].change_direction(-1.0,enemy_body)
		if enemy_body.global_position.y > 820:
			enemy_body.movement(0.0,[-1.0])
		elif enemy_body.global_position.y < 805:
			enemy_body.movement(0.0,[1.0])
		else:
			enemy_body.movement(0.0,[0.0])
	if !is_instance_valid(boss_body):
		if ray_cast_2d.get_collider() != null:
			cur_direction = Vector2(1.0,0.0)
		else:
			cur_direction.y = -1.0
		enemy_body.movement(cur_direction.x,[cur_direction.y])

func _on_timer_timeout():
	if is_instance_valid(boss_body):
		enemy_body.shoot()
	else:
		timer.stop()
		enemy_body.body_resources["Body_change_direction"].change_direction(-1.0,enemy_body)

func _on_area_2d_body_entered(body):
	if body is Moving_body and body != self:
		if body.type != enemy_body.type and not body.type in GlobalSapphire.type_friendlists[enemy_body.type]:
			cur_target = body

func _on_robot_body_now_dead():
	GlobalSapphire.player_savedata.other_data["Destroyed_Unknown_head"] = true
	queue_free()
