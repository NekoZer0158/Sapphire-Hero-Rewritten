class_name Hack_planes_Projectile
extends Node2D

@export var type : GlobalEnum.BodyTypes
@export var id : int = 0
@export var speed : int

var atk : int = 0

func _physics_process(delta):
	position.y += speed*delta


func _on_area_2d_area_entered(area):
	var area_parent = area.get_parent()
	if area_parent != null:
		if area_parent is Hack_planes_Plane:
			if area_parent.type != type:
				area_parent.hit(atk)
				queue_free()
		else:
			queue_free()

func _on_area_2d_body_entered(_body):
	queue_free()
