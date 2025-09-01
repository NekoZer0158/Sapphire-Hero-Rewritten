class_name Flying_body_extended
extends Flying_body

@export var backward_markers : Array[Marker2D]

func shoot() -> void:
	if shooting_module != null:
		shoot_animation()
		if can_use_weapon and (ammo[cur_weapon].x >= shooting_module.weapons[cur_weapon].ammo_per_shot or ammo[cur_weapon].x < 0):
			if shooting_module.use_module([markers,cur_weapon,scale.y,type]) and shooting_module.use_module([backward_markers,cur_weapon,-scale.y,type]):
				if !infinite_ammo:
					ammo[cur_weapon].x -= shooting_module.weapons[cur_weapon].ammo_per_shot
				emit_signal("use_weapon",ammo[cur_weapon].x)
				can_use_weapon = false
				if is_instance_valid(timer_reload):
					timer_reload.start(reload_time)
				else:
					push_error("no timer_reload")

func death() -> void:
	dead = true
	emit_signal("now_dead")
	if has_death_effect:
		if is_instance_valid(death_effect):
			var spawn_death_effect = death_effect.instantiate()
			spawn_death_effect.position = death_effect_marker.global_position/4
			get_parent().get_parent().get_parent().add_child(spawn_death_effect)
		else:
			push_error("No death_effect when body has_death_effect")
	queue_free()
