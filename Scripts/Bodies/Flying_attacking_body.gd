class_name Flying_attacking_body
extends Flying_body

@export var attacking_area : Area2D
@export var atk : int

var cur_targets : Array[Moving_body] = []

func _on_attack_area_body_entered(body):
	if body is Moving_body:
		if body.type != type and not body.type in GlobalSapphire.type_friendlists[type]:
			cur_targets.append(body)
			body.hit(atk)
			timer_reload.start(reload_time)

func _on_attack_area_body_exited(body):
	if body is Moving_body:
		if body in cur_targets:
			cur_targets.erase(body)

func _on_timer_reload_timeout():
	for i in cur_targets:
		if is_instance_valid(i):
			i.hit(atk)
	if cur_targets.size() == 0:
		timer_reload.stop()
