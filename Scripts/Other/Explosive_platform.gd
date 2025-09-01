extends StaticBody2D

@export var boom : PackedScene

@onready var boom_markers = $Boom_markers

signal explosion_activated()

func explosion() -> void:
	for i in boom_markers.get_children():
		spawn_boom(i)
	queue_free()

func _on_area_2d_body_entered(body):
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			emit_signal("explosion_activated")
			explosion()

func spawn_boom(boom_marker:Marker2D) -> void:
	var new_boom = boom.instantiate()
	new_boom.global_position = boom_marker.global_position/4
	get_parent().add_child(new_boom)
