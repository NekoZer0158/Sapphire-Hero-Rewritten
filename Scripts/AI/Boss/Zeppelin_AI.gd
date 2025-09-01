extends Boss_AI

@onready var timer_shoot = $Timer_shoot
@onready var timer_jumped = $Timer_jumped

var jumped : bool = false

var time_after_jump : float = 0.4

func check_boss_state() -> void:
	if is_instance_valid(boss_body):
		match phase:
			0:
				if timer_shoot.is_stopped():
					timer_shoot.start(boss_body.reload_time+0.6)
				change_boss_body_direction()
			1:
				boss_body.movement(1.0)
			2:
				boss_body.movement(0.0)
				change_boss_body_direction()
			3:
				boss_body.movement(0.0)
				change_boss_body_direction()

func change_boss_body_direction() -> void:
	if is_instance_valid(GlobalSapphire.player):
		if is_instance_valid(GlobalSapphire.player.player_body):
			if GlobalSapphire.player.player_body.global_position > boss_body.global_position:
				boss_body.change_direction(1.0)
			else:
				boss_body.change_direction(-1.0)

func check_if_needed_to_change_state() -> void:
	if is_instance_valid(boss_body):
		match phase:
			0:
				if boss_body.hp <= 7:
					phase = 1
			2:
				if boss_body.hp <= 3:
					phase = 3
					timer_shoot.start(boss_body.reload_time+0.4)

func _on_timer_shoot_timeout():
	match phase:
		0,2,3:
			boss_body.shoot()

func _on_boss_body_nearby_tile():
	if !jumped:
		boss_body.jump(true)
		jumped = true
		timer_jumped.start(time_after_jump)

func _on_timer_jumped_timeout():
	change_boss_body_direction()
	boss_body.movement(0.0)
	phase = 2
	timer_shoot.start(boss_body.reload_time+0.5)
