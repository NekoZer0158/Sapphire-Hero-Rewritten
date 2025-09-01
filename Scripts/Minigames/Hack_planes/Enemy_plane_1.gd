extends Hack_planes_Plane

@export var raycast_left : RayCast2D
@export var raycast_right : RayCast2D

var cur_direction : float = 1.0

func controls() -> void:
	if can_shoot:
		shoot()
	if raycast_left.get_collider() != null:
		cur_direction = 1.0
	if raycast_right.get_collider() != null:
		cur_direction = -1.0
	movement_x(cur_direction)
