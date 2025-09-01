extends Node2D

@onready var riding_body : Robot_body = $Riding_robot
@onready var riding_head : Flying_body = $Riding_robot/Flying_head_riding
@onready var timer_change_direction = $Timer_change_direction
@onready var raycast_right : RayCast2D = $Riding_robot/RayCast_right

var cur_movement : float = 1.0
var can_change_direction : bool = true
var cur_target : Moving_body
var head_movement : Vector2

func _ready():
	riding_body.type = GlobalEnum.BodyTypes.ENEMY
	riding_head.type = GlobalEnum.BodyTypes.ENEMY

func _physics_process(_delta):
	if is_instance_valid(riding_head):
		riding_head.shoot()
	if is_instance_valid(riding_body):
		riding_body.movement(cur_movement)
		if raycast_right.get_collider() != null and can_change_direction:
			cur_movement = -cur_movement
			can_change_direction = false
			timer_change_direction.start(0.5)
	elif is_instance_valid(riding_head) and is_instance_valid(cur_target):
		if cur_target.global_position.x-300 > riding_head.global_position.x:
			head_movement.x = 1.0
		elif cur_target.global_position.x+300 < riding_head.global_position.x:
			head_movement.x = -1.0
		else:
			head_movement.x = 0.0
		if cur_target.global_position.y-145 > riding_head.global_position.y:
			head_movement.y = 1.0
		elif cur_target.global_position.y+145 < riding_head.global_position.y:
			head_movement.y = -1.0
		else:
			head_movement.y = 0.0
		riding_head.movement(head_movement.x,[head_movement.y])


func _on_timer_change_direction_timeout():
	can_change_direction = true

func _on_riding_robot_now_dead():
	riding_body.remove_child(riding_head)
	riding_head.global_position = riding_body.global_position/4-global_position/4+riding_head.position
	call_deferred("add_child",riding_head)


func _on_area_2d_body_entered(body):
	if body is Moving_body:
		if body.type != riding_head.type and not body.type in GlobalSapphire.type_friendlists[riding_head.type]:
			cur_target = body

func _on_flying_head_riding_now_dead():
	queue_free()
