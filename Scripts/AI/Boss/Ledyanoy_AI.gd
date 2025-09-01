extends Boss_AI

@onready var timer_shoot = $Timer_shoot

var cur_target : Robot_body

const distance : float = 150.0

func boss_moving() -> void:
	if is_instance_valid(cur_target):
		if cur_target.global_position.x > boss_body.global_position.x:
			if boss_body.scale.y == -1:
				boss_body.change_direction(-boss_body.scale.y)
			if abs(cur_target.global_position.x-boss_body.global_position.x) > distance:
				boss_body.movement(1.0)
			else:
				boss_body.movement(0.0)
		else:
			if boss_body.scale.y == 1:
				boss_body.change_direction(-boss_body.scale.y)
			if abs(cur_target.global_position.x-boss_body.global_position.x) > distance:
				boss_body.movement(-1.0)
			else:
				boss_body.movement(0.0)

func check_boss_state() -> void:
	match phase:
		0:
			if timer_shoot.is_stopped():
				timer_shoot.start(boss_body.reload_time+0.1)
			boss_moving()

func check_if_needed_to_change_state() -> void:
	match phase:
		0:
			pass

func _on_boss_body_detected_a_body(detected_body):
	if detected_body is Moving_body:
		if detected_body.type != boss_body.type and not detected_body.type in GlobalSapphire.type_friendlists[boss_body.type]:
			cur_target = detected_body

func _on_timer_shoot_timeout():
	boss_body.shoot()

func _on_area_2d_area_entered(area):
	var area_parent = area.get_parent()
	if area_parent != null:
		if area_parent is Projectile:
			if area_parent.type != boss_body.type:
				boss_body.jump(true)


func _on_area_2d_nearby_body_entered(body):
	if body is Moving_body:
		if body.type != boss_body.type and not body.type in GlobalSapphire.type_friendlists[boss_body.type]:
			boss_body.jump(true)
