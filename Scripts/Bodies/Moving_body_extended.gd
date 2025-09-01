class_name Moving_body_extended
extends Moving_body

signal detected_a_body(detected_body)
signal no_ground()
signal nearby_tile()

func change_direction(direction:float) -> void:
	body_resources["Body_change_direction"].change_direction(direction,self)

func _on_vision_detected_a_robot_body(detected_body):
	emit_signal("detected_a_body",detected_body)

func _on_ground_check_no_ground():
	emit_signal("no_ground")

func _on_nearby_tile():
	emit_signal("nearby_tile")
