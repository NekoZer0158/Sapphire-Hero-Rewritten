extends Node2D

@export var raycasts : Array[RayCast2D]

var cur_collider : Node2D
var activated : bool = false

signal no_ground()

func _physics_process(_delta):
	if activated:
		for i in raycasts:
			cur_collider = i.get_collider()
			if cur_collider == null:
				emit_signal("no_ground")

func _on_timer_timeout():
	activated = true
