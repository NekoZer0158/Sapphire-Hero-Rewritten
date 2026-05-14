@icon("res://Sprites/Icons/Turret_three_shot.svg")
extends Node2D

@onready var turret : Static_Robot_body = $Turret_body

var three_shot : int = 0

signal turret_destroyed()
signal play_sound_for_shot(from_position:float)

func _ready():
	if scale.y == -1:
		scale.y = 1
		rotation_degrees = 0
		turret.scale.y = 1
		turret.rotation_degrees = 0

func _on_reload_ended():
	if three_shot < 3:
		if turret.can_use_weapon:
			turret.shoot()
			three_shot += 1
			play_sound_for_shot.emit(0.0)
	else:
		three_shot = 0

func _on_timer_timeout():
	if is_instance_valid(turret):
		if turret.can_use_weapon:
			turret.shoot()
			three_shot += 1
			play_sound_for_shot.emit(0.0)
	else:
		queue_free()


func _on_turret_body_now_dead() -> void:
	turret_destroyed.emit()
