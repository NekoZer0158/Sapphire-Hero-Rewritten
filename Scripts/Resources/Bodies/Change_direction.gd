class_name Body_change_direction
extends Resource

func change_direction(cur_direction:float,body:Robot_body) -> void:
	if cur_direction < 0:
		body.scale.y = -1
		body.rotation_degrees = 180
	elif cur_direction > 0:
		body.scale.y = 1
		body.rotation_degrees = 0

func check_parent_node_scale_y(parent_node:Node,body:Robot_body) -> void:
	if parent_node.scale.y == -1:
		parent_node.scale.y = 1
		parent_node.rotation_degrees = 0
		change_direction(-1.0,body)
