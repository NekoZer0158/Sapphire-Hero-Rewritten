class_name Flying_robot_AI
extends Node2D

@onready var enemy_body : Flying_body = $Robot_body

var activate_enemy : bool = false

func _ready():
	enemy_body.type = GlobalEnum.BodyTypes.ENEMY
	if !is_instance_valid(enemy_body):
		push_error("No enemy_body")
	start()

func start() -> void:
	pass
