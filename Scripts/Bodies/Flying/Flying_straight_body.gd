class_name Flying_straight_body
extends Flying_attacking_body

@export var collision_shapes : Array[CollisionShape2D]
@export var timer_anim : Timer

const time_for_anim_change : float = 0.08

var deactivate_spikes : bool = false

signal spikes_deactivated()

func use_spike(which_one:int) -> void:
	deactivate_spikes = false
	collision_shapes[which_one].set_deferred("disabled",false)
	body_sprite.frame = (which_one+1)*4
	timer_anim.start(time_for_anim_change)

func stop_using_spike() -> void:
	deactivate_spikes = true
	timer_anim.start(time_for_anim_change)

func _on_timer_anim_timeout():
	if deactivate_spikes:
		body_sprite.frame -= 1
	else:
		body_sprite.frame += 1
	if body_sprite.frame_coords.x == 3 or body_sprite.frame_coords.x == 0:
		timer_anim.stop()
		if body_sprite.frame_coords.x == 0:
			for i in collision_shapes:
				i.set_deferred("disabled",true)
			emit_signal("spikes_deactivated")
