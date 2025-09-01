class_name Lever
extends Activate_object

@onready var animation_player = $AnimationPlayer

signal lever_activation()

func activate(_player:Moving_body) -> void:
	animation_player.play("lever_use")
	can_be_activated = false

func _on_animation_player_animation_finished(_anim_name):
	emit_signal("lever_activation")
