@icon("res://Sprites/Icons/Enemy_soldier.svg")
class_name Default_enemy_AI
extends Node2D

@onready var enemy_body = $Enemy_body
@onready var timer_attacking = $Timer_attacking
@onready var timer_change_idle_state = $Timer_change_idle_state
@onready var timer_check_everywhere = $Timer_check_everywhere

const time_for_check_back : float = 0.2
const time_for_attacking_state : float = 10.0
const time_for_change_idle_state : float = 0.75
const time_for_change_idle_state_worried : float = 2.5
const distance_between_me_and_target : float = 700.0

var cur_time_for_change_idle_state : float = time_for_change_idle_state
var cur_state : GlobalEnum.EnemyState = GlobalEnum.EnemyState.IDLE
var idle_state : int = 0:
	set(value):
		if value > 3:
			idle_state = 0
		else:
			idle_state = value
var attacking_state : int = 0:
	set(value):
		if value > 1 or value < 0:
			value = 0
		else:
			attacking_state = value
var cur_target : Robot_body

func _ready():
	if is_instance_valid(enemy_body):
		enemy_body.type = GlobalEnum.BodyTypes.ENEMY
		timer_change_idle_state.start(cur_time_for_change_idle_state)
	else:
		push_error("No enemy_body")

func moving(state:int):
	match state:
		0:
			if enemy_body.is_on_floor():
				enemy_body.movement(0.0)
			else:
				enemy_body.movement(-1.0)
		1:
			enemy_body.movement(1.0)
		2:
			if enemy_body.is_on_floor():
				enemy_body.movement(0.0)
			else:
				enemy_body.movement(1.0)
		3:
			enemy_body.movement(-1.0)

func _physics_process(_delta):
	if is_instance_valid(enemy_body):
		match cur_state:
			GlobalEnum.EnemyState.IDLE:
				moving(idle_state)
			GlobalEnum.EnemyState.ATTACKING:
				if is_instance_valid(cur_target):
					if abs(cur_target.global_position.x-enemy_body.global_position.x) <= distance_between_me_and_target:
						attacking_state = 1
					else:
						attacking_state = 0
				match attacking_state:
					0:
						if is_instance_valid(cur_target):
							if cur_target.global_position.x > enemy_body.global_position.x:
								enemy_body.movement(1.0)
							else:
								enemy_body.movement(-1.0)
						else:
							cur_target = null
							cur_state = GlobalEnum.EnemyState.WORRIED
					1:
						if is_instance_valid(cur_target):
							if cur_target.global_position.x > enemy_body.global_position.x:
								change_body_direction(1.0)
							else:
								change_body_direction(-1.0)
						else:
							cur_target = null
							cur_state = GlobalEnum.EnemyState.WORRIED
						if enemy_body.is_on_floor():
							enemy_body.movement(0.0)
						else:
							if enemy_body.scale.y == 1:
								enemy_body.movement(1.0)
							else:
								enemy_body.movement(-1.0)
						enemy_body.shoot()
			GlobalEnum.EnemyState.WORRIED:
				moving(idle_state)

func _on_enemy_body_detected_a_body(detected_body):
	if detected_body.type != enemy_body.type and not detected_body.type in GlobalSapphire.type_friendlists[GlobalEnum.BodyTypes.ENEMY]:
		cur_state = GlobalEnum.EnemyState.ATTACKING
		cur_target = detected_body
		timer_change_idle_state.stop()
		timer_attacking.start(time_for_attacking_state)

func _on_timer_attacking_timeout():
	cur_state = GlobalEnum.EnemyState.WORRIED
	cur_time_for_change_idle_state = time_for_change_idle_state_worried
	timer_change_idle_state.start(cur_time_for_change_idle_state)

func _on_timer_change_idle_state_timeout():
	idle_state += 1
	if idle_state%2 == 0:
		timer_change_idle_state.start(time_for_change_idle_state)
	else:
		timer_change_idle_state.start(cur_time_for_change_idle_state)

func _on_enemy_body_no_ground():
	if enemy_body.is_on_floor():
		enemy_body.jump(true)

func _on_enemy_body_got_hit(_new_hp):
	if !is_instance_valid(cur_target):
		match cur_state:
			GlobalEnum.EnemyState.IDLE:
				cur_state = GlobalEnum.EnemyState.WORRIED
				cur_time_for_change_idle_state = time_for_change_idle_state_worried
				idle_state = 0
				change_direction_and_check_everywhere()
			GlobalEnum.EnemyState.WORRIED:
				change_direction_and_check_everywhere()
	
func change_direction_and_check_everywhere() -> void:
	timer_change_idle_state.stop()
	change_body_direction(-enemy_body.scale.y)
	timer_check_everywhere.start(time_for_check_back)

func _on_timer_check_everywhere_timeout():
	if  cur_state != GlobalEnum.EnemyState.ATTACKING:
		change_body_direction(-enemy_body.scale.y)
		timer_change_idle_state.start(cur_time_for_change_idle_state)

func change_body_direction(body_direction:float) -> void:
	if enemy_body.mirror_sprite:
		enemy_body.body_resources["Body_change_direction"].change_direction(body_direction,enemy_body)

func _on_enemy_body_nearby_tile():
	match cur_state:
		GlobalEnum.EnemyState.IDLE,GlobalEnum.EnemyState.WORRIED:
			match idle_state:
				1,3:
					enemy_body.jump(true)
		GlobalEnum.EnemyState.ATTACKING:
			enemy_body.jump(true)

func _on_enemy_body_now_dead():
	queue_free()
