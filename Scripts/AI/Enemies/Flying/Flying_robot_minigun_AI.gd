extends Flying_robot_left_right

@export var time_between : float = 1.5
@export var amount_of_shoots : int = 5

@onready var timer_one_shoot = $Timer_one_shoot
@onready var timer_change_frame = $Timer_change_frame
@onready var sprite_reload = $Robot_body/Sprite_reload

var cur_amount_of_shoots : int = 0
var time_for_one_shot : float = 0.13
var time_for_change_frames : float = 0.0

func start():
	if is_instance_valid(timer):
		timer.queue_free()
	sprite_reload.frame = 0
	time_for_change_frames = time_between/sprite_reload.hframes
	timer_change_frame.start(time_for_change_frames)
	if time_for_change_frames < 0.06:
		push_warning("Time is too short")
	if !is_instance_valid(raycast_left) or !is_instance_valid(raycast_right):
		push_error("Problem with raycasts")

func _on_timer_one_shoot_timeout():
	if is_instance_valid(enemy_body):
		enemy_body.shoot()
		cur_amount_of_shoots += 1
		if cur_amount_of_shoots >= amount_of_shoots:
			timer_one_shoot.stop()
			sprite_reload.frame = 0
			timer_change_frame.start(time_for_change_frames)
			cur_amount_of_shoots = 0
	else:
		queue_free()

func _on_timer_change_frame_timeout():
	if is_instance_valid(sprite_reload):
		if sprite_reload.frame < sprite_reload.hframes-1:
			sprite_reload.frame += 1
		else:
			timer_one_shoot.start(time_for_one_shot)
			timer_change_frame.stop()
