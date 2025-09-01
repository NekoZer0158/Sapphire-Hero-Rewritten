class_name Moving_body
extends Robot_body

@export var jump_velocity : float = -550.0
@export var amount_of_jumps : int = 1
var max_amount_of_jumps : int

# Speed
var speed_increase_on_floor : float = speed/6 ## changes the default speed, not a changed one
var speed_increase_in_air : float = speed/9 ## changes the default speed, not a changed one
var speed_decrease_on_floor : float = speed/8 ## changes the default speed, not a changed one
var speed_decrease_in_air : float = speed/45 ## changes the default speed, not a changed one
var speed_when_start_animation : float # start

@export_group("Timers")
@export var timer_jump : Timer
@export var timer_fall : Timer

@export_group("Animations")
@export var left_arm_anim : AnimationPlayer
@export var right_arm_anim : AnimationPlayer
@export var legs_anim : AnimationPlayer

@export_group("Extra")
@export var sliding : bool = false
@export var inertia : bool = true

# timer jump
var jump_button_pressed : bool = false
const available_time_for_jump : float = 0.15

# timer fall
var jump_after_fall : bool = false
var timer_fall_activated : bool = false
const short_time_after_fall : float = 0.18
const max_falling_speed : int = 5000

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func start() -> void:
	max_amount_of_jumps = amount_of_jumps
	speed_when_start_animation = speed*0.75
	if sliding:
		speed_decrease_on_floor = speed/35
		speed_decrease_in_air = speed/100

func _physics_process(delta):
	if not is_on_floor():
		if velocity.y < max_falling_speed: # if controls feels bad, remove this
			velocity.y += gravity * delta * 3
		else:
			velocity.y = max_falling_speed
		if !timer_fall_activated and amount_of_jumps == max_amount_of_jumps:
			timer_fall_activated = true
			jump_after_fall = true
			timer_fall.start(short_time_after_fall)
	else:
		if amount_of_jumps < max_amount_of_jumps and velocity.y == 0:
			amount_of_jumps = max_amount_of_jumps
			timer_fall_activated = false
			timer_fall.stop()
			jump_after_fall = false
	if jump_button_pressed:
		jump(false)
	move_and_slide()

func movement(cur_direction:float,_other_args:Array=[]) -> void:
	var direction = cur_direction
	if mirror_sprite:
		body_resources["Body_change_direction"].change_direction(direction,self)
	set_animations()
	if direction > 0:
		if velocity.x < speed:
			if is_on_floor():
				velocity.x += speed_increase_on_floor
			else:
				velocity.x += speed_increase_in_air
		else:
			velocity.x = speed
	elif direction < 0:
		if velocity.x > -speed:
			if is_on_floor():
				velocity.x -= speed_increase_on_floor
			else:
				velocity.x -= speed_increase_in_air
		else:
			velocity.x = -speed
	else:
		if inertia:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, speed_decrease_on_floor)
			else:
				velocity.x = move_toward(velocity.x, 0, speed_decrease_in_air)
		else:
			velocity.x = 0

func set_animations() -> void:
	if velocity.y != 0 or !is_on_floor():
		check_anim_and_play("in_air")
	elif abs(velocity.x) > speed_when_start_animation:
		right_arm_anim.play("moving")
		if left_arm_anim.current_animation != "shoot":
			left_arm_anim.play("moving")
			left_arm_anim.seek(right_arm_anim.current_animation_position)
		legs_anim.play("moving")
	else:
		check_anim_and_play()

func check_anim_and_play(play_this_anim:String="nothing") -> void:
	if left_arm_anim.current_animation != "shoot":
		left_arm_anim.play(play_this_anim)
	right_arm_anim.play(play_this_anim)
	legs_anim.play(play_this_anim)

func jump(pressed_jump:bool) -> void:
	if amount_of_jumps > 0:
		if jump_after_fall:
			velocity.y = jump_velocity
			jump_after_fall = false
			timer_fall.stop()
			amount_of_jumps -= 1
		elif is_on_floor() or amount_of_jumps > 0:
			velocity.y = jump_velocity
			amount_of_jumps -= 1
			jump_button_pressed = false
			timer_jump.stop()
	elif pressed_jump:
		jump_button_pressed = true
		timer_jump.start(available_time_for_jump)

func shoot_animation() -> void:
	if left_arm_anim.current_animation != "shoot":
		left_arm_anim.play("shoot")
	else:
		left_arm_anim.seek(0)

func _on_timer_jump_timeout():
	jump_button_pressed = false

func _on_timer_fall_timeout():
	jump_after_fall = false
	amount_of_jumps -= 1

func _on_left_arm_anim_animation_finished(anim_name):
	match anim_name:
		"shoot":
			if velocity.y == 0:
				if velocity.x == 0:
					left_arm_anim.play("nothing")
				else:
					left_arm_anim.play("moving")
					left_arm_anim.seek(right_arm_anim.current_animation_position)
			else:
				left_arm_anim.play("in_air")
