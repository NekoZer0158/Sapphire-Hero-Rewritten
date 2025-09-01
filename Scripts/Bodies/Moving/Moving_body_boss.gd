class_name Moving_body_boss
extends Moving_body_extended

const hit_including_projectile := true

@export var working_projectiles : Array[int]
@export var not_working_projectils : Array[int]

func hit_extended(dmg : int,p:Projectile) -> void:
	if dmg > def and !immortal and not p.id in not_working_projectils:
		if !immortality:
			if p.id in working_projectiles:
				hp -= (dmg*2)-def
			else:
				hp -= dmg-def
			emit_signal("got_hit",hp)
			if immortality_frames and hp > 0:
				activate_immortality_frames()
		if hp <= 0 and !dead:
			death()
