class_name Body_weapon_change
extends Resource

func change_weapon(default_color:Color,new_weapon:int,cur_weapon:int,ammo:Array,body_sprite:Sprite2D,can_change_color:bool,shooting_module:Shooting_module) -> int:
	if cur_weapon + new_weapon < ammo.size():
		if cur_weapon + new_weapon < 0:
			cur_weapon = ammo.size()-1
		else:
			cur_weapon += new_weapon
	else:
		cur_weapon = 0
	if can_change_color:
		if shooting_module.weapons[cur_weapon] is Weapon_with_colors:
			change_color(shooting_module.weapons[cur_weapon].body_color,body_sprite)
		else:
			change_color(default_color,body_sprite)
	return cur_weapon

func change_color(new_color:Color,body_sprite:Sprite2D):
	if is_instance_valid(body_sprite):
		if body_sprite.material != null:
			body_sprite.material["shader_parameter/color"] = new_color
		else:
			push_error("there is no material in body_sprite")
