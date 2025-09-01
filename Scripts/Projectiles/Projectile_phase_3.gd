extends Projectile

@onready var marker_2d = $Marker2D

func _on_area_2d_body_entered(body):
	if body is Robot_body or body is Static_Robot_body:
		if body.type != type and not body.type in GlobalSapphire.type_friendlists[type]:
			body.hit(atk)
			queue_free()
	elif body is TileMapLayer or body is Object:
		spawn_default_enemy_projectile()
	else:
		queue_free()

func spawn_default_enemy_projectile() -> void:
	var projectile : Projectile
	projectile = GlobalSapphire.projectiles_database.projectiles[2].instantiate()
	projectile.type = type
	projectile.global_position = marker_2d.global_position
	projectile.speed *= scale.y
	projectile.speed.y = -abs(projectile.speed.x/1.8)
	projectile.speed.x = -projectile.speed.x*1.7
	projectile.life_time += 4
	if scale.y < 0:
		projectile.rotation_degrees = -15
	else:
		projectile.rotation_degrees = 15
	projectile.scale *= scale.y
	get_parent().call_deferred("add_child",projectile)
	queue_free()
