extends Boss_AI

@export var attack_area_atk : int = 4
@export var time_for_change_direction : float = 0.3
@export var amount_of_direction_change_before_state_change : int = 5
@export var time_for_shooting : float = 8.0
@export var time_shooting : float = 0.8

@onready var attack_area_collision_shape_2d = $Boss_body/Attack_area/CollisionShape2D
@onready var ray_cast_2d_check_wall = $Boss_body/RayCast2D_check_wall
@onready var timer_change_direction = $Timer_change_direction
@onready var timer_stop_shooting = $Timer_stop_shooting
@onready var timer_shoot = $Timer_shoot

var can_change_direction : bool = true

var cur_direction : float = 1.0
var cur_target : Moving_body
var max_amount_of_direction_change_before_state_change : int
var can_shoot : bool = false

var main_node

enum {NOTHING,STANDING_AND_SHOOTING,RUSH}

signal now_boss_dead(global_pos:Vector2)

func start() -> void:
	cur_target = GlobalSapphire.player.player_body
	if cur_target.global_position.x < boss_body.global_position.x:
		boss_body.body_resources["Body_change_direction"].change_direction(-1.0,boss_body)
	boss_body = $Boss_body
	boss_body.got_hit.connect(boss_UI._on_boss_body_got_hit)
	max_amount_of_direction_change_before_state_change = amount_of_direction_change_before_state_change

func change_ui() -> void:
	boss_body = $Boss_body
	boss_body.got_hit.connect(boss_UI._on_boss_body_got_hit)

func check_boss_state() -> void:
	if is_instance_valid(boss_body) and is_instance_valid(cur_target):
		match phase:
			NOTHING:
				boss_body.movement(0.0)
			STANDING_AND_SHOOTING:
				if cur_target.global_position > boss_body.global_position:
					if boss_body.scale.y != 1:
						boss_body.change_direction(1.0)
				else:
					if boss_body.scale.y != -1:
						boss_body.change_direction(-1.0)
				boss_body.movement(0.0)
				if can_shoot:
					boss_body.shoot()
			RUSH:
				boss_body.movement(cur_direction)
				if ray_cast_2d_check_wall.get_collider() != null and can_change_direction:
					can_change_direction = false
					boss_body.velocity.x = -boss_body.velocity.x
					cur_direction = -cur_direction
					amount_of_direction_change_before_state_change -= 1
					timer_change_direction.start(time_for_change_direction)
					if amount_of_direction_change_before_state_change == 0:
						timer_stop_shooting.start(time_for_shooting)
						attack_area_collision_shape_2d.set_deferred("disabled",true)
						timer_shoot.start(time_shooting)
						phase = STANDING_AND_SHOOTING
						amount_of_direction_change_before_state_change = max_amount_of_direction_change_before_state_change

func check_if_needed_to_change_state() -> void:
	pass

func _on_attack_area_body_entered(body):
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			body.hit(attack_area_atk)

func _on_timer_change_direction_timeout():
	can_change_direction = true

func _on_timer_start_timeout():
	if is_instance_valid(boss_body):
		activated = true
		can_shoot = false
		attack_area_collision_shape_2d.set_deferred("disabled",false)
		phase = RUSH

func _on_timer_stop_shooting_timeout():
	if is_instance_valid(boss_body):
		match phase:
			STANDING_AND_SHOOTING:
				can_shoot = false
				phase = NOTHING
				timer_stop_shooting.start(0.9)
			NOTHING:
				attack_area_collision_shape_2d.set_deferred("disabled",false)
				phase = RUSH

func _on_timer_shoot_timeout():
	can_shoot = true

func _boss_death():
	emit_signal("now_boss_dead",boss_body.global_position)
	queue_free()
