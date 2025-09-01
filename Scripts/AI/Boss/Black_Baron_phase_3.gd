extends Boss_AI

@onready var timer = $Timer

var can_change_direction : bool = true

var cur_direction : float = 1.0
var cur_target : Moving_body
var max_amount_of_direction_change_before_state_change : int
var can_shoot : bool = false

var amount_of_walls : int = 2
var main_node

signal now_boss_dead(global_pos:Vector2)

func start() -> void:
	cur_target = GlobalSapphire.player.player_body
	if cur_target.global_position.x < boss_body.global_position.x:
		boss_body.change_direction(-1.0)
	boss_body = $Boss_body
	boss_body.got_hit.connect(boss_UI._on_boss_body_got_hit)
	boss_body.change_weapon(0)

func change_ui() -> void:
	boss_body = $Boss_body
	boss_body.got_hit.connect(boss_UI._on_boss_body_got_hit)

func check_boss_state() -> void:
	if is_instance_valid(boss_body) and is_instance_valid(cur_target):
		match phase:
			1:
				if cur_target.global_position > boss_body.global_position:
					if boss_body.scale.y != 1:
						boss_body.change_direction(1.0)
				else:
					if boss_body.scale.y != -1:
						boss_body.change_direction(-1.0)
				boss_body.movement(0.0)
				if can_shoot:
					boss_body.shoot()

func check_if_needed_to_change_state() -> void:
	pass

func _on_timer_timeout() -> void:
	if amount_of_walls > 0:
		amount_of_walls -= 1
		boss_body.shoot()
	elif phase == 0:
		boss_body.change_weapon(1)
		phase = 1
	else:
		can_shoot = true
		activated = true
		timer.stop()

func _boss_death():
	emit_signal("now_boss_dead",boss_body.global_position)
	queue_free()
