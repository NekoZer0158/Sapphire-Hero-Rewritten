class_name Projectile_speed_increase
extends Projectile

var cur_speed : Vector2
var speed_increase : Vector2

func start() -> void:
	speed_increase = speed/18

func _physics_process(delta):
	if activated:
		if cur_speed < speed:
			cur_speed += speed_increase
		elif cur_speed > speed:
			cur_speed = speed
		position += cur_speed * delta
