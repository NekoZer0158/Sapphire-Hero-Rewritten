class_name Projectile_with_animation
extends Projectile

@export var animation_player : AnimationPlayer

func start() -> void:
	if is_instance_valid(animation_player):
		animation_player.play("default")
	else:
		push_error("No animation_player")
