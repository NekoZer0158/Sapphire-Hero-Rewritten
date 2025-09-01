class_name Clouds_remover
extends Area2D

signal removed_cloud()

func _on_area_entered(area):
	var area_parent = area.get_parent()
	if area_parent != null:
		if area_parent is Cloud:
			area_parent.queue_free()
			emit_signal("removed_cloud")
