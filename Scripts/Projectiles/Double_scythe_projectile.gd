class_name Double_scythe_projectile
extends Projectile

var owner_body : Robot_body

var cur_state : int = 0
var real_life_time : float
var cur_speed : Vector2

var speed_decrease : Vector2

func start() -> void:
	$AnimationPlayer.play("scythe")
	speed_decrease = speed/30.0
	real_life_time = life_time*13
	match type:
		GlobalEnum.BodyTypes.ENEMY:
			if is_instance_valid(GlobalSapphire.cur_boss):
				owner_body = GlobalSapphire.cur_boss.boss_body
		GlobalEnum.BodyTypes.PLAYER:
			if is_instance_valid(GlobalSapphire.player):
				owner_body = GlobalSapphire.player.player_body
	if !is_instance_valid(owner_body):
		push_error("no owner_body")

func _physics_process(delta):
	if activated and is_instance_valid(owner_body):
		match cur_state:
			0:
				global_position += speed * delta
			1:
				if speed.x > 0:
					if owner_body.global_position.x > global_position.x:
						if cur_speed < speed:
							cur_speed += speed_decrease
						global_position += cur_speed * delta
					else:
						if cur_speed >  -speed:
							cur_speed -= speed_decrease
						global_position += cur_speed * delta
				else:
					if owner_body.global_position.x > global_position.x:
						if cur_speed < -speed:
							cur_speed += -speed_decrease
						global_position += cur_speed * delta
					else:
						if cur_speed >  speed:
							cur_speed -= -speed_decrease
						global_position += cur_speed * delta

func _on_timer_life_timeout():
	match cur_state:
		0:
			cur_state = 1
			life_timer.start(real_life_time)
		1:
			queue_free()

func _on_area_2d_area_entered(area):
	if area.get_parent() != null:
		if area.get_parent() is Projectile and not area.get_parent() is Double_scythe_projectile:
			area.get_parent().queue_free()
