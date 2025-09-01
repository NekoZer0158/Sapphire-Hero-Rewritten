class_name Body_shooting
extends Resource

func shooting(body:Robot_body) -> void:
	if body.can_use_weapon and (body.ammo[body.cur_weapon].x >= body.shooting_module.weapons[body.cur_weapon].ammo_per_shot or body.ammo[body.cur_weapon].x < 0):
		if body.shooting_module.use_module([body.markers,body.cur_weapon,body.scale.y,body.type]):
			body.ammo_change(body.shooting_module.weapons[body.cur_weapon].ammo_per_shot)
			body.emit_signal("use_weapon",body.ammo[body.cur_weapon].x)
			body.can_use_weapon = false
			if is_instance_valid(body.timer_reload):
				body.timer_reload.start(body.reload_time)
			else:
				push_error("no timer_reload")
