extends Level

@export var area_underground : Area2D

var achievement_sprite := preload("res://Sprites/UI/Achievements/No_turrets.png")
var amount_of_destroyed_turrets : int = 0
var all_turrets : int = 0

func start() -> void:
	if !is_instance_valid(area_underground):
		push_error("no area_underground")
	for _i in get_tree().get_nodes_in_group("Turret_three_shot"):
		all_turrets += 1

func _on_area_underground_body_entered(body):
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			change_camera_to_underground(body.get_parent().player_camera)

func change_camera_to_underground(player_camera:Camera2D):
	player_camera.limit_top = 1080
	player_camera.limit_bottom = 1080*2
	player_camera.limit_left = int(area_underground.global_position.x)


func _on_camera_borders_change_player_entered():
	for i in get_tree().get_nodes_in_group("Cloud"):
		i.queue_free()
	for i in get_tree().get_nodes_in_group("Cloud_spawner"):
		i.queue_free()


func _on_turret_three_shot_turret_destroyed() -> void:
	amount_of_destroyed_turrets += 1
	if amount_of_destroyed_turrets == all_turrets and not "No_turrets" in GlobalSapphire.achievements_data.unlocked_achievements:
		GlobalSapphire.get_this_achievement_and_save("No_turrets")
		GlobalSapphire.player.player_UI._got_achievement("No_turrets",achievement_sprite)
		
