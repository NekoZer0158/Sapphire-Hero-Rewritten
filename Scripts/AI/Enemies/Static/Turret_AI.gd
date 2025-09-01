@icon("res://Sprites/Icons/Turret.svg")
class_name Default_Turret_AI
extends Node2D

@onready var turret : Static_Robot_body = $Turret_body

var first_shoot : bool = true

func _ready():
	turret.type = GlobalEnum.BodyTypes.ENEMY
	if scale.y == -1 or scale.x == -1:
		scale.y = 1
		scale.x = 1
		rotation_degrees = 0
		turret.scale.y = 1
		turret.rotation_degrees = 0

func _on_reload_ended():
	turret.shoot()

func _on_timer_timeout():
	if is_instance_valid(turret):
		if first_shoot:
			first_shoot = false
			turret.shoot()
