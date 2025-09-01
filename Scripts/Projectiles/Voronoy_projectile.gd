extends Projectile

@export var speed_y_when_target : int
var target : Node2D
var pos_difference : int = 64

func _physics_process(delta):
	if activated:
		if is_instance_valid(target) and abs(target.global_position.y-global_position.y-pos_difference) > 8:
			if target.global_position.y-pos_difference < global_position.y:
				position += (speed-Vector2(0,speed_y_when_target)) * delta
			elif target.global_position.y-pos_difference > global_position.y:
				position += (speed+Vector2(0,speed_y_when_target)) * delta
			else:
				position += speed * delta
		else:
			position += speed * delta

func _on_area_2d_target_body_entered(body: Node2D) -> void:
	if body is Robot_body or body is Static_Robot_body:
		if body.type != type and not body.type in GlobalSapphire.type_friendlists[type]:
			if body is Flying_body:
				pos_difference = 0
			elif body is Static_Robot_body:
				pos_difference = 48
			else:
				pos_difference = 64
			target = body

func _on_area_2d_target_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
