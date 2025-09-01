extends Boss_AI

@export var raycast_tiles : RayCast2D
@onready var timer_change_direction = $Timer_change_direction
@onready var timer_shoot = $Timer_shoot
@onready var timer_jump = $Timer_jump

var cur_direction : float = -1.0
var change_direction : bool = true

func check_boss_state() -> void:
	if is_instance_valid(boss_body):
		match phase:
			0:
				if timer_shoot.is_stopped():
					boss_body.shoot()
					timer_shoot.start(1.5)
				standart_boss_movement()
			1:
				if is_instance_valid(GlobalSapphire.player):
					if is_instance_valid(GlobalSapphire.player.player_body):
						if GlobalSapphire.player.player_body.global_position.y+125 < boss_body.global_position.y:
							boss_body.jump(true)
				standart_boss_movement()
			2:
				if is_instance_valid(GlobalSapphire.player):
					if is_instance_valid(GlobalSapphire.player.player_body):
						if GlobalSapphire.player.player_body.global_position.y+125 < boss_body.global_position.y:
							boss_body.jump(true)
				standart_boss_movement()
				if timer_jump.is_stopped():
					timer_jump.start(0.8)
					timer_shoot.start(1.7)
			3:
				if is_instance_valid(GlobalSapphire.player):
					if is_instance_valid(GlobalSapphire.player.player_body):
						if GlobalSapphire.player.player_body.global_position.y+125 < boss_body.global_position.y:
							boss_body.jump(true)
				standart_boss_movement()
				if timer_shoot.is_stopped():
					timer_shoot.start(1.3)

func standart_boss_movement() -> void:
	boss_body.movement(cur_direction)
	if raycast_tiles.get_collider() != null and change_direction:
		cur_direction = -cur_direction
		timer_change_direction.start(0.5)
		change_direction = false

func check_if_needed_to_change_state() -> void:
	if is_instance_valid(boss_body):
		match phase:
			0:
				if boss_body.hp <= 13:
					phase = 1
			1:
				if boss_body.hp <= 8:
					phase = 2
			2:
				if boss_body.hp <= 4:
					phase = 3
					timer_shoot.stop()

func _on_timer_change_direction_timeout():
	change_direction = true

func _on_timer_shoot_timeout():
	if is_instance_valid(boss_body):
		boss_body.shoot()

func _on_timer_jump_timeout():
	if is_instance_valid(boss_body):
		boss_body.jump(true)
		boss_body.shoot()

func _on_boss_body_nearby_tile():
	if is_instance_valid(boss_body):
		boss_body.jump(true)
