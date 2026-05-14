class_name Flying_robot_AI
extends Node2D

@onready var enemy_body : Flying_body = $Robot_body

var activate_enemy : bool = false

signal play_sound_for_shot(from_position:float)

func _ready():
	enemy_body.type = GlobalEnum.BodyTypes.ENEMY
	if !is_instance_valid(enemy_body):
		push_error("No enemy_body")
	start()

func start() -> void:
	pass
