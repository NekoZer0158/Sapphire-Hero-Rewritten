class_name Projectile_power
extends Projectile_with_animation

@export var power : int = 0

func _on_area_2d_body_entered(body):
	if body is Robot_body or body is Static_Robot_body:
		if body.type != type and not body.type in GlobalSapphire.type_friendlists[type]:
			if "hit_including_projectile" in body:
				body.hit_extended(atk,self)
			else:
				body.hit(atk)
			#if body is Robot_body:
				#body.velocity.x += power*atk*sign(scale.y)
			queue_free()
	elif body is Breakable_box:
		body.hit(id)
		queue_free()
	else:
		queue_free()
