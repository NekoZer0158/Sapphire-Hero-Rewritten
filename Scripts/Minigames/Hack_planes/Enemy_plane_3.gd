extends Hack_planes_Plane

@export var raycast_left : RayCast2D
@export var raycast_right : RayCast2D

var cur_direction : float = 1.0

func controls() -> void:
	if can_shoot:
		shoot_three_times()
	if raycast_left.get_collider() != null:
		cur_direction = 1.0
	if raycast_right.get_collider() != null:
		cur_direction = -1.0
	movement_x(cur_direction)

func shoot_three_times() -> void:
	can_shoot = false
	screen.spawn_projectile(projectile_id,atk,shooting_marker.global_position)
	await get_tree().create_timer(0.1,false).timeout
	screen.spawn_projectile(projectile_id,atk,shooting_marker.global_position)
	await get_tree().create_timer(0.1,false).timeout
	screen.spawn_projectile(projectile_id,atk,shooting_marker.global_position)
	await get_tree().create_timer(0.1,false).timeout
	timer_shoot.start(reload_time)
