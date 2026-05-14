class_name Cutscene_activator
extends Area2D

signal player_entered_area()

var activated : bool = false

func _on_body_entered(body):
	if body is Robot_body and !activated:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			player_entered_area.emit()
			activated = true
