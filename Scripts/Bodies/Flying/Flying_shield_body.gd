class_name Flying_shield_body
extends Flying_attacking_body

@export var time_for_shield : float = 5.0

@onready var shield : StaticBody2D = $Shield
@onready var timer_shield = $Timer_shield

var shield_collisions : Array[Node]
var using_shield : bool = false

func start_2() -> void:
	if is_instance_valid(shield):
		shield_collisions = shield.get_children()
	else:
		push_error("No shield")
	if !is_instance_valid(body_sprite):
		push_error("There is not body_sprite")

func _on_attack_area_body_entered(body):
	if body is Moving_body:
		if body.type != type and not body.type in GlobalSapphire.type_friendlists[type]:
			cur_targets.append(body)
			body.hit(atk)
			timer_reload.start(reload_time)

func hit(dmg : int) -> void:
	if dmg > def and !immortal:
		if !immortality:
			hp -= dmg-def
			if cur_targets.size() == 0:
				activate_shiled()
			emit_signal("got_hit",hp)
			if immortality_frames and hp > 0:
				activate_immortality_frames()
		if hp <= 0 and !dead:
			death()

func activate_shiled() -> void:
	timer_shield.start(time_for_shield)
	using_shield = true
	body_sprite.frame = 1
	for i in shield_collisions:
		i.set_deferred("disabled",false)

func _on_timer_shield_timeout():
	body_sprite.frame = 0
	using_shield = false
	for i in shield_collisions:
		i.set_deferred("disabled",true)
