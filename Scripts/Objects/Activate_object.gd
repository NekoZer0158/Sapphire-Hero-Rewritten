class_name Activate_object
extends Node2D

@onready var enter_area : Area2D = $Enter_area

var can_be_activated : bool = true:
	set(value):
		if !value:
			enter_area.monitoring = false
		else:
			enter_area.monitoring = true
		can_be_activated = value

func activate(_player:Moving_body) -> void:
	pass

func _on_enter_area_body_entered(body):
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			body.get_parent().enable_activation(self)

func _on_enter_area_body_exited(body):
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			if body.get_parent().object_activation == self:
				body.get_parent().disable_activation()
