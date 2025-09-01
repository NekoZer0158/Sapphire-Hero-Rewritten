class_name Laser_wall
extends Projectile

@onready var center = $Node2D

func _physics_process(delta):
	if activated:
		center.rotation_degrees += speed.y * delta

func _on_area_2d_body_entered(_body):
	pass

func _on_area_2d_area_entered(area):
	var area_parent = area.get_parent()
	if area_parent is Projectile:
		if area_parent.type != type:
			area_parent.queue_free()
