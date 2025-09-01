extends Flying_body

@export var atk : int = 1
@export var time_get_back_to_top : float = 0.5

var cur_target : Moving_body
var activated : bool = false:
	set(value):
		activated = value
		if value:
			await get_tree().create_timer(0.3,false).timeout
			attack_area_collision_shape_2d.set_deferred("disabled",false)
var cur_movement : Vector2
var go_to_player : bool = false
@onready var timer = $Timer
@onready var attack_area_collision_shape_2d: CollisionPolygon2D = $Attack_area/CollisionShape2D

signal spawn_next_phase()

func start_2() -> void:
	type = GlobalEnum.BodyTypes.ENEMY

func _physics_process(delta):
	super ._physics_process(delta)
	if activated and is_instance_valid(cur_target):
		#print(abs(global_position.y-cur_target.global_position.y))
		if abs(global_position.y-cur_target.global_position.y) > 550:
			if cur_target.global_position.x > global_position.x:
				cur_movement.x = 1.0
			else:
				cur_movement.x = -1.0
		if !go_to_player:
			cur_movement.y = 1.0
			go_to_player = true
		else:
			pass
		movement(cur_movement.x,[cur_movement.y])
		if (is_on_floor()) and cur_movement.y > 0:
			cur_movement.y = -1.0
			timer.start(time_get_back_to_top)

func _on_timer_timeout():
	go_to_player = false

func _on_area_2d_body_entered(body):
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			cur_target = body

func _on_attack_area_body_entered(body):
	if body is Moving_body and activated:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			body.hit(atk)

func hit(dmg : int) -> void:
	if dmg > def and !immortal and activated:
		if !immortality:
			hp -= dmg-def
			emit_signal("got_hit",hp)
			if immortality_frames and hp > 0:
				activate_immortality_frames()
		if hp <= 0 and !dead:
			death()

func death() -> void:
	dead = true
	emit_signal("now_dead")
	if has_death_effect:
		if is_instance_valid(death_effect):
			var spawn_death_effect = death_effect.instantiate()
			spawn_death_effect.scale *= 4
			spawn_death_effect.position = death_effect_marker.global_position
			GlobalSapphire.add_child(spawn_death_effect)
		else:
			push_error("No death_effect when body has_death_effect")
	queue_free()
