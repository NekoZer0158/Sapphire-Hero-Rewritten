extends Node2D

@onready var turret : Static_Robot_body = $Turret_body

var three_shot : int = 0

signal turret_destroyed()

func _ready():
	if scale.y == -1:
		scale.y = 1
		rotation_degrees = 0
		turret.scale.y = 1
		turret.rotation_degrees = 0

func _on_reload_ended():
	if three_shot < 3:
		turret.shoot()
		three_shot += 1
	else:
		three_shot = 0

func _on_timer_timeout():
	if is_instance_valid(turret):
		turret.shoot()
		three_shot += 1
	else:
		queue_free()


func _on_turret_body_now_dead() -> void:
	emit_signal("turret_destroyed")
