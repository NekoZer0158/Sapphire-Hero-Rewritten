extends Projectile

@export var real_speed: int = 0

func start() -> void:
	if is_instance_valid(GlobalSapphire.player):
		if is_instance_valid(GlobalSapphire.player.player_body):
			speed = real_speed * (global_position.direction_to(GlobalSapphire.player.player_body.global_position)/4)
