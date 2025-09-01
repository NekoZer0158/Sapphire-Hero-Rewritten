class_name Flying_body
extends Robot_body

@export var animation_player : AnimationPlayer
# Speed
var speed_increase_in_air : float = speed/6
var speed_decrease_in_air : float = speed/8

func start():
	animation_player.play("flying_robot_flame")
	start_2()

func start_2():
	pass

func _physics_process(_delta):
	move_and_slide()

func movement(cur_direction:float,other_args:Array=[]) -> void:
	var direction = cur_direction
	if mirror_sprite:
		body_resources["Body_change_direction"].change_direction(direction,self)
	if direction > 0:
		if velocity.x < speed:
			velocity.x += speed_increase_in_air
		else:
			velocity.x = speed
	elif direction < 0:
		if velocity.x > -speed:
			velocity.x -= speed_increase_in_air
		else:
			velocity.x = -speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed_decrease_in_air)
	if other_args.size() == 1:
		if typeof(other_args[0]) == TYPE_FLOAT:
			if other_args[0] > 0:
				if velocity.y < speed:
					velocity.y += speed_increase_in_air
				else:
					velocity.y = speed
			elif other_args[0] < 0:
				if velocity.y > -speed:
					velocity.y -= speed_increase_in_air
				else:
					velocity.y = -speed
			else:
				velocity.y = move_toward(velocity.y, 0, speed_decrease_in_air)
	else:
		push_warning("More then enough arguments or not enough arguments")
