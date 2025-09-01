extends Level

@onready var marker_2d_elevator = $Marker2D_elevator
@onready var marker_2d_level_end = $Marker2D_level_end
@onready var marker_2d_level_end_left_side = $Marker2D_level_end_left_side
@export var remove_this_areas_when_in_the_base : Array[Area2D]
@export var remove_this_parallax : ParallaxBackground

var achievement_sprite := preload("res://Sprites/UI/Achievements/Spikes.png")

var activated_area2d : bool = false
var can_get_spikes_achievement : bool = true

func start() -> void:
	for i in get_tree().get_nodes_in_group("Without_spikes"):
		i.now_dead.connect(_cannot_get_achievement)
	if cur_checkpoint != 0:
		can_get_spikes_achievement = false

func _cannot_get_achievement() -> void:
	can_get_spikes_achievement = false

func _on_area_2d_body_entered(body):
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER and !activated_area2d:
			body.get_parent().player_camera.limit_right = marker_2d_level_end.global_position.x
			body.get_parent().player_camera.limit_top = marker_2d_elevator.global_position.y-1080
			body.get_parent().player_camera.limit_bottom = marker_2d_elevator.global_position.y
			body.get_parent().player_camera.set_deferred("limit_smoothed",true)
			body.get_parent().player_camera.call_deferred("reset_smoothing")
			activated_area2d = true
			for i in remove_this_areas_when_in_the_base:
				if is_instance_valid(i):
					i.queue_free()
			for i in get_tree().get_nodes_in_group("Cloud"):
				i.queue_free()
			for i in get_tree().get_nodes_in_group("Cloud_spawner"):
				i.queue_free()
			if is_instance_valid(remove_this_parallax):
				remove_this_parallax.queue_free()

func _on_area_2d_spikes_body_entered(body: Node2D) -> void:
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			if can_get_spikes_achievement and check_levels() and cur_checkpoint == 0 and not "Spikes" in GlobalSapphire.achievements_data.unlocked_achievements:
				GlobalSapphire.get_this_achievement_and_save("Spikes")
				GlobalSapphire.player.player_UI._got_achievement("Spikes",achievement_sprite)

func check_levels() -> bool:
	var levels : int = 0 
	for i in GlobalSapphire.player_savedata.completed_levels.keys():
		levels += GlobalSapphire.player_savedata.completed_levels[i]
	if levels < 4:
		return true
	return false
