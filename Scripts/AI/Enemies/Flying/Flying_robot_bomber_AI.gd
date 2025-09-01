@icon("res://Sprites/Icons/Flying_robot_bomber.svg")
class_name Flying_robot_left_right
extends Flying_robot_AI

@onready var timer : Timer = $Timer
@onready var raycast_left : RayCast2D = $Robot_body/RayCast_left
@onready var raycast_right : RayCast2D = $Robot_body/RayCast_right

var cur_movement : float = 1.0

func start():
	if is_instance_valid(timer):
		timer.start(enemy_body.reload_time+0.1)
	else:
		push_error("no timer")
	if !is_instance_valid(raycast_left) or !is_instance_valid(raycast_right):
		push_error("Problem with raycasts")

func _physics_process(_delta):
	if is_instance_valid(enemy_body):
		if raycast_left.is_colliding():
			cur_movement = 1.0
		if raycast_right.is_colliding():
			cur_movement = -1.0
		enemy_body.movement(cur_movement,[0.0])

func _on_timer_timeout():
	if is_instance_valid(enemy_body):
		enemy_body.shoot()
	else:
		queue_free()


func _on_flying_robot_bomber_now_dead():
	queue_free()
