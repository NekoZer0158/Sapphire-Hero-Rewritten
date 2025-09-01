@icon("res://Sprites/Icons/Flying_robot_straight.svg")
extends Flying_robot_AI

@onready var ray_cast_up = $Robot_body/RayCast_Up
@onready var ray_cast_right = $Robot_body/RayCast_Right
@onready var ray_cast_down = $Robot_body/RayCast_Down
@onready var ray_cast_left = $Robot_body/RayCast_Left

@onready var near_ray_cast_up = $Robot_body/Near_raycasts/RayCast_Up
@onready var near_ray_cast_right = $Robot_body/Near_raycasts/RayCast_Right
@onready var near_ray_cast_down = $Robot_body/Near_raycasts/RayCast_Down
@onready var near_ray_cast_left = $Robot_body/Near_raycasts/RayCast_Left

var in_process : bool = false
var cur_direction : int = -1

func start() -> void:
	pass

func _physics_process(_delta):
	if is_instance_valid(enemy_body):
		if !in_process:
			if check_collider(ray_cast_up.get_collider()):
				move_straight(0)
			elif check_collider(ray_cast_right.get_collider()):
				move_straight(1)
			elif check_collider(ray_cast_down.get_collider()):
				move_straight(2)
			elif check_collider(ray_cast_left.get_collider()):
				move_straight(3)
			else:
				enemy_body.movement(0,[0.0])
		else:
			move()
			if (near_ray_cast_up.get_collider() != null and cur_direction == 0) or (near_ray_cast_right.get_collider() != null and cur_direction == 1) or (near_ray_cast_down.get_collider() != null and cur_direction == 2) or (near_ray_cast_left.get_collider() != null and cur_direction == 3):
				enemy_body.movement(0,[0.0])
				cur_direction = -1
				enemy_body.stop_using_spike()

func check_collider(collider:Object) -> bool:
	if collider is Moving_body:
		if collider.type != enemy_body.type and collider.type not in GlobalSapphire.type_friendlists[enemy_body.type]:
			return true
	return false

func move_straight(direction:int) -> void:
	if is_instance_valid(enemy_body):
		cur_direction = direction
		move()
		in_process = true
		enemy_body.use_spike(direction)

func move() -> void:
	match cur_direction:
		0:
			enemy_body.movement(0,[-1.0])
		1:
			enemy_body.movement(1,[0.0])
		2:
			enemy_body.movement(0,[1.0])
		3:
			enemy_body.movement(-1,[0.0])

func _on_robot_body_spikes_deactivated():
	in_process = false
