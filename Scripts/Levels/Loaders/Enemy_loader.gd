extends Node

func spawn_enemies(level:Node) -> void:
	const DEFAULT_TURRET = preload("res://Scenes/Enemies/Static/Default_turret.tscn")
	const TURRET_THREE_SHOT = preload("res://Scenes/Enemies/Static/Turret_three_shot.tscn")
	const DEFAULT_ENEMY_SLOWER = preload("res://Scenes/Enemies/Moving/Default_enemy_slower.tscn")
	const DEFAULT_ENEMY = preload("res://Scenes/Enemies/Moving/Default_enemy.tscn")
	const DEFAULT_ENEMY_HEALTHIER = preload("res://Scenes/Enemies/Moving/Default_enemy_healthier.tscn")
	const ICE_SPIDER = preload("res://Scenes/Enemies/Static/Ice_spider.tscn")
	const FLYING_ROBOT_BOMBER = preload("res://Scenes/Enemies/Flying/Flying_robot_bomber.tscn")
	const FLYING_ROBOT_DRILL = preload("res://Scenes/Enemies/Flying/Flying_robot_drill.tscn")
	const FLYING_ROBOT_GROUND_HIT = preload("res://Scenes/Enemies/Flying/Flying_robot_ground_hit.tscn")
	const FLYING_ROBOT_SPIKED = preload("res://Scenes/Enemies/Flying/Flying_robot_spiked.tscn")
	const FLYING_ROBOT_MINIGUN = preload("res://Scenes/Enemies/Flying/Flying_robot_minigun.tscn")
	var enemies_node:= level.get_node_or_null("Enemies")
	if enemies_node != null:
		var all_enemies := enemies_node.get_children()
		for i in all_enemies:
			if i is Marker2D:
				var new_enemy : Node2D
				if i.name.begins_with("DefaultTurret") or i.name.begins_with("Default_turret"):
					new_enemy = DEFAULT_TURRET.instantiate()
				elif i.name.begins_with("TurretThreeShot") or i.name.begins_with("Turret_three_shot"):
					new_enemy = TURRET_THREE_SHOT.instantiate()
				elif i.name.begins_with("GMR-27"):
					new_enemy = DEFAULT_ENEMY_SLOWER.instantiate()
				elif i.name.begins_with("GMR-28"):
					new_enemy = DEFAULT_ENEMY.instantiate()
				elif i.name.begins_with("GMR-29"):
					new_enemy = DEFAULT_ENEMY_HEALTHIER.instantiate()
				elif i.name.begins_with("Ice_spider") or i.name.begins_with("IceSpider"):
					new_enemy = ICE_SPIDER.instantiate()
				elif i.name.begins_with("Flying_robot_bomber") or i.name.begins_with("FlyingRobotBomber"):
					new_enemy = FLYING_ROBOT_BOMBER.instantiate()
				elif i.name.begins_with("Flying_robot_drill") or i.name.begins_with("FlyingRobotDrill"):
					new_enemy = FLYING_ROBOT_DRILL.instantiate()
				elif i.name.begins_with("Flying_robot_ground_hit") or i.name.begins_with("FlyingRobotGroundHit"):
					new_enemy = FLYING_ROBOT_GROUND_HIT.instantiate()
				elif i.name.begins_with("Flying_robot_spiked") or i.name.begins_with("FlyingRobotSpiked"):
					new_enemy = FLYING_ROBOT_SPIKED.instantiate()
				elif i.name.begins_with("Flying_robot_machinegun") or i.name.begins_with("FlyingRobotMachinegun"):
					new_enemy = FLYING_ROBOT_MINIGUN.instantiate()
				set_position_scale_and_rotation_for_enemy(new_enemy,i)
				enemies_node.add_child(new_enemy)
			i.queue_free()

func set_position_scale_and_rotation_for_enemy(enemy:Node2D,enemy_marker:Marker2D) -> void:
	enemy.global_position = enemy_marker.global_position/4
	enemy.scale = enemy_marker.scale
	enemy.rotation = enemy_marker.rotation
