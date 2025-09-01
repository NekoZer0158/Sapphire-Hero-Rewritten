extends Boss_AI

@export var timer_shoot_time : Timer

@onready var destryoed_core_sprite = $Destryoed_core_sprite
@onready var timer_frame_change = $Timer_frame_change
@onready var last_core_sprite = $Last_core_sprite

var bottom_core := preload("res://Scenes/Story/Characters/Bottom_core.tscn")
var time_for_frame_change : float = 0.8

signal the_end()

func start() -> void:
	timer_shoot_time.start(boss_body.reload_time+0.3)

func _on_timer_shoot_time_timeout():
	if activated and is_instance_valid(boss_body) and is_instance_valid(GlobalSapphire.player):
		if is_instance_valid(GlobalSapphire.player.player_body):
			boss_body.shoot()
		else:
			timer_shoot_time.stop()

func _on_boss_body_now_dead():
	destryoed_core_sprite.show()
	timer_frame_change.start(4)

func _on_timer_frame_change_timeout():
	if destryoed_core_sprite.frame < 10:
		if destryoed_core_sprite.frame == 2:
			destryoed_core_sprite.frame = 4
		else:
			destryoed_core_sprite.frame += 1
		if destryoed_core_sprite.frame == 2:
			timer_frame_change.start(time_for_frame_change)
			emit_signal("end_level")
	else:
		timer_frame_change.stop()

func _last_frame_for_core() -> void:
	var new_bottom_core := bottom_core.instantiate()
	destryoed_core_sprite.frame = 11
	var new_timer = get_tree().create_timer(0.5,false)
	await new_timer.timeout
	last_core_sprite.show()
	last_core_sprite.add_child(new_bottom_core)
	destryoed_core_sprite.hide()
	new_timer = get_tree().create_timer(5.5,false)
	await new_timer.timeout
	emit_signal("the_end")
