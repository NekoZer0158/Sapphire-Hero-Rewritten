extends Boss_AI

@export var time_between_jumps : float = 1.2
@export var distance : int = 250
@onready var timer_jump: Timer = $Timer_jump

func check_boss_state() -> void:
	if is_instance_valid(boss_body):
		match phase:
			0,1:
				if is_instance_valid(GlobalSapphire.player.player_body):
					if GlobalSapphire.player.player_body.global_position.x-boss_body.global_position.x < -distance:
						boss_body.movement(-1.0)
					elif GlobalSapphire.player.player_body.global_position.x-boss_body.global_position.x > distance:
						boss_body.movement(1.0)
					else:
						if GlobalSapphire.player.player_body.global_position.x < boss_body.global_position.x:
							boss_body.change_direction(-1.0)
						else:
							boss_body.change_direction(1.0)
						boss_body.movement(0.0)
					if boss_body.can_use_weapon:
						boss_body.shoot()
				else:
					boss_body.movement(0.0)

func check_if_needed_to_change_state() -> void:
	if is_instance_valid(boss_body):
		match phase:
			0:
				if boss_body.hp < 9:
					phase = 1
					timer_jump.start(time_between_jumps)

func _on_timer_jump_timeout() -> void:
	if is_instance_valid(boss_body):
		boss_body.jump(true)
