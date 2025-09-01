class_name Vision
extends Node2D

@export var raycasts : Array[RayCast2D]
@export var raycast_legs : RayCast2D
@export var parent_body : Robot_body
@export var detect_this_type_of_bodies : Array[GlobalEnum.BodyTypes]

var cur_collider : Node2D

signal detected_a_robot_body(detected_body:Robot_body)
signal nearby_tile()

func _physics_process(_delta):
	for i in raycasts:
		cur_collider = i.get_collider()
		if cur_collider != null:
			if cur_collider is Robot_body:
				if cur_collider.type in detect_this_type_of_bodies:
					emit_signal("detected_a_robot_body",cur_collider)
	if raycast_legs.get_collider() is TileMapLayer:
		emit_signal("nearby_tile")
