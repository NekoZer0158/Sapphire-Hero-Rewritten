class_name Riding_robot
extends Robot_body

@export var animation_player : AnimationPlayer

# Speed
var speed_increase_on_floor : float = speed/6
var speed_decrease_on_floor : float = speed/8

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func start():
	if is_instance_valid(animation_player):
		animation_player.play("riding")
	else:
		push_error("No animation_player")

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta * 3
	move_and_slide()

func movement(cur_direction:float,_other_args:Array=[]) -> void:
	var direction = cur_direction
	if mirror_sprite:
		body_resources["Body_change_direction"].change_direction(direction,self)
	if direction > 0:
		if velocity.x < speed:
			velocity.x += speed_increase_on_floor
		else:
			velocity.x = speed
	elif direction < 0:
		if velocity.x > -speed:
			velocity.x -= speed_increase_on_floor
		else:
			velocity.x = -speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed_decrease_on_floor)

func shoot() -> void:
	pass

func shoot_animation() -> void:
	pass
