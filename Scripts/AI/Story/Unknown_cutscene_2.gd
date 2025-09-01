extends Node2D

enum {STANDING,MOVING}

@export var robot_body : Robot_body
@export var time_before_moving : float = 0.4

@onready var color_rect = $UI/ColorRect
@onready var timer_short = $Timer_short

var phase := STANDING

var swords_activated : bool = false

signal destroy_core()

func _ready():
	robot_body.type = GlobalEnum.BodyTypes.ENEMY

func _physics_process(_delta):
	match phase:
		STANDING:
			robot_body.movement(0.0)
		MOVING:
			robot_body.movement(1.0)

func show_robot() -> void:
	show()
	phase = MOVING

func _on_unknown_body_no_ground():
	phase = STANDING
	if !swords_activated:
		if is_instance_valid(robot_body):
			swords_activated = true
			robot_body.activate_swords()
			timer_short.start(1.5)
		else:
			push_error("No robot_body")

func transition(alpha:float,time:float) -> bool:
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(color_rect,"self_modulate",Color(0.0,0.0,0.0,alpha),time)
	await new_tween.finished
	return true

func _on_timer_short_timeout():
	await transition(1.0,0.6)
	robot_body.hide()
	await get_tree().create_timer(0.6).timeout
	emit_signal("destroy_core")
	await transition(0.0,0.6)
	queue_free()
