@icon("res://Sprites/Icons/Enemy_soldier_healthier.svg")
class_name Enemy_healthier_AI
extends Default_enemy_AI

@export var no_one_eye : bool = false

func _ready() -> void:
	super()
	if no_one_eye:
		$Enemy_body/Body/Head.texture = load("res://Sprites/Enemies/Moving/Soldiers/Healthier/Head_no_one_eye.png")
