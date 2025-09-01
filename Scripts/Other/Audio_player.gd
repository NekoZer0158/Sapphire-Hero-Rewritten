extends Node

@export var audiostreamplayers : Array[AudioStreamPlayer2D]
@export var time_min : float
@export var time_max : float

func activate_audio() -> void:
	for i in audiostreamplayers:
		i.play()
		await get_tree().create_timer(randf_range(time_min,time_max),false).timeout

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Robot_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			activate_audio()
