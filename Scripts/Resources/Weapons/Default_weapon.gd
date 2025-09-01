class_name Default_weapon
extends Weapon

func use_weapon(markers:Array[Marker2D],direction:float,type:GlobalEnum.BodyTypes) -> void:
	var projectile : Projectile
	if projectile_ids.size() == 1:
		projectile = GlobalSapphire.projectiles_database.projectiles[projectile_ids[0]].instantiate()
		set_projectile(projectile,markers[0],direction,type)
	else:
		push_error("Not enough or too many ids")
