class_name Moving_mine
extends Robot_body

@export var animation_player : AnimationPlayer

# Speed
var speed_increase_on_floor : float = speed/6
var speed_decrease_on_floor : float = speed/8

var activated : bool = false

func start():
	if markers.size() < 2:
		push_error("Not enough markers")
		get_parent().queue_free()

func _physics_process(_delta):
	if activated:
		move_and_slide()

func movement(cur_direction:float,_other_args:Array=[]) -> void:
	if activated and can_use_weapon:
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
	if activated and velocity.x == 0:
		if shooting_module != null:
			if can_use_weapon and (ammo[cur_weapon].x >= shooting_module.weapons[cur_weapon].ammo_per_shot or ammo[cur_weapon].x < 0):
				shoot_animation()
				can_use_weapon = false

func shoot_animation() -> void:
	animation_player.play("shoot")

func _on_activation_area_body_entered(body):
	if body is Robot_body:
		if body.type != type and not body.type in GlobalSapphire.type_friendlists[type]:
			activated = true

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"shoot":
			var array_with_right_marker : Array[Marker2D] = [markers[0]]
			var array_with_left_marker : Array[Marker2D] = [markers[1]]
			if shooting_module.use_module([array_with_right_marker,cur_weapon,scale.y,type]) and shooting_module.use_module([array_with_left_marker,cur_weapon,-scale.y,type]):
				if !infinite_ammo:
					ammo[cur_weapon].x -= shooting_module.weapons[cur_weapon].ammo_per_shot
				emit_signal("use_weapon",ammo[cur_weapon].x)
				if is_instance_valid(timer_reload):
					timer_reload.start(reload_time)
				else:
					push_error("no timer_reload")
				animation_player.play("back_to_normal")
