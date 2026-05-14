@icon("res://Sprites/Icons/Turret.svg")
class_name Default_Turret_AI
extends Node2D

@onready var turret : Static_Robot_body = $Turret_body

var first_shoot : bool = true

signal play_sound_for_shot(from_position:float)

func _ready():
	turret.type = GlobalEnum.BodyTypes.ENEMY
	if scale.y == -1 or scale.x == -1:
		scale.y = 1
		scale.x = 1
		rotation_degrees = 0
		turret.scale.y = 1
		turret.rotation_degrees = 0

func _on_reload_ended():
	if turret.can_use_weapon:
		turret.shoot()
		play_sound_for_shot.emit(0.0)

func _on_timer_timeout():
	if is_instance_valid(turret):
		if first_shoot:
			first_shoot = false
			if turret.can_use_weapon:
				turret.shoot()
				play_sound_for_shot.emit(0.0)
