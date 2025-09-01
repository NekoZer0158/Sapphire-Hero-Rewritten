class_name Pickup
extends Node2D

func use_pickup(_body:Robot_body) -> void:
	pass

func _on_pickup_area_body_entered(body):
	if body is Robot_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			use_pickup(body)
			queue_free()
