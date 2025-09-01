class_name Hack_planes_Plane
extends CharacterBody2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var shooting_marker : Marker2D = $Marker2D
@onready var timer_shoot : Timer = $Timer_shoot

@export var type : GlobalEnum.BodyTypes
@export var hp : int = 3
@export var atk : int = 1
@export var speed : float = 50.0
@export var reload_time : float = 0.5
@export var projectile_id : int = 0

var can_shoot : bool = true
var dead : bool = false
var screen : CanvasLayer

signal now_dead()
signal got_hit(new_hp:int)

func _ready():
	if get_parent().get_parent() is CanvasLayer:
		screen = get_parent().get_parent()
	if !is_instance_valid(animation_player):
		push_error("There is no animation_player")
		queue_free()
	else:
		animation_player.play("default")
	if !is_instance_valid(shooting_marker):
		push_error("There is no shooting_marker")
		queue_free()
	start()

func start() -> void:
	pass

func _physics_process(_delta):
	move_and_slide()
	controls()

func hit(dmg) -> void:
	hp -= dmg
	emit_signal("got_hit",hp)
	if hp <= 0 and !dead:
		dead = true
		emit_signal("now_dead")
		queue_free()

func movement_x(cur_direction:float) -> void:
	if cur_direction != 0:
		velocity.x = speed * sign(cur_direction)
	else:
		velocity.x = 0

func movement_y(cur_direction:float) -> void:
	if cur_direction != 0:
		velocity.y = speed * sign(cur_direction)
	else:
		velocity.y = 0

func controls() -> void:
	pass

func shoot() -> void:
	if can_shoot:
		screen.spawn_projectile(projectile_id,atk,shooting_marker.global_position)
		can_shoot = false
		timer_shoot.start(reload_time)

func _on_timer_shoot_timeout():
	can_shoot = true

func _on_hit_area_area_entered(area):
	var body = area.get_parent()
	if body is Hack_planes_Plane:
		if body.type != type and body != self and body.type != GlobalEnum.BodyTypes.ENEMY:
			body.hit(atk)
