extends Projectile_with_animation

@export var timer_2 : Timer
@export var time_for_spawning_zw2 : float

var zeppelin_weapon_2 = preload("res://Scenes/Projectiles/Zeppelin_weapon_2.tscn")

func start() -> void:
	super .start()
	use_zw2()
	timer_2.start(time_for_spawning_zw2)


func _on_timer_2_timeout():
	use_zw2()

func use_zw2() -> void:
	var zw2_1 : Projectile = zeppelin_weapon_2.instantiate()
	var zw2_2 : Projectile = zeppelin_weapon_2.instantiate()
	zw2_2.speed.y = -zw2_2.speed.y
	if scale.y == -1:
		zw2_1.speed.x = -zw2_1.speed.x
		zw2_2.speed.x = -zw2_2.speed.x
	zw2_1.type = type
	zw2_2.type = type
	zw2_1.global_position = global_position
	zw2_2.global_position = global_position
	get_parent().add_child(zw2_1)
	get_parent().add_child(zw2_2)
