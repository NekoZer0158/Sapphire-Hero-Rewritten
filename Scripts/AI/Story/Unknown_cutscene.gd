extends Node2D

enum {STANDING,MOVING}

@export var robot_body : Robot_body
@export var time_before_moving : float = 0.4

@onready var timer = $Timer
@onready var timer_hide = $Timer_hide

var phase := STANDING

func _ready():
	if !is_instance_valid(robot_body):
		push_error("No robot_body")
	else:
		robot_body.type = GlobalEnum.BodyTypes.ENEMY

func _physics_process(_delta):
	match phase:
		STANDING:
			robot_body.movement(0.0)
		MOVING:
			robot_body.movement(1.0)

func _change_state_to_moving() -> void:
	phase = MOVING

func _show_robot() -> void:
	show()
	if timer.is_stopped():
		timer.start(time_before_moving)

func _change_state_to_standing() -> void:
	phase = STANDING
	if timer_hide.is_stopped():
		timer_hide.start(time_before_moving)

func _go_away() -> void:
	queue_free()
