extends Flying_robot_AI

@onready var attacked_vision = $Robot_body/Area2D/Attacked_vision
@onready var default_vision = $Robot_body/Area2D/CollisionShape2D

var cur_direction_x : float = -1.0
var cur_direction_y: float = 1.0

var cur_target : Moving_body

const timer_anim_time : float = 0.2

func _physics_process(_delta):
	if is_instance_valid(enemy_body):
		if activate_enemy:
			if is_instance_valid(cur_target):
				if abs(abs(cur_target.global_position.x)-abs(enemy_body.global_position.x)) > 175 or !enemy_body.using_shield:
					if cur_target.global_position.x > enemy_body.global_position.x:
						cur_direction_x = 1.0
					else:
						cur_direction_x = -1.0
				else:
					cur_direction_x = 0.0
				if abs(abs(cur_target.global_position.y) - abs(enemy_body.global_position.y)) > 250 or !enemy_body.using_shield:
					if cur_target.global_position.y-50 < enemy_body.global_position.y:
						cur_direction_y = -1.0
					elif cur_target.global_position.y-90 > enemy_body.global_position.y:
						cur_direction_y = 1.0
					else:
						cur_direction_y = 0.0
				else:
					cur_direction_y = 0.0
			enemy_body.movement(cur_direction_x,[cur_direction_y])

func _on_area_2d_body_entered(body):
	if body is Moving_body and is_instance_valid(enemy_body):
		if body.type != enemy_body.type and not body.type in GlobalSapphire.type_friendlists[GlobalEnum.BodyTypes.ENEMY]:
			activate_enemy = true
			cur_target = body

func _on_flying_robot_spiked_got_hit(_new_hp):
	attacked_vision.set_deferred("disabled",false)

func _on_flying_robot_spiked_now_dead():
	queue_free()
