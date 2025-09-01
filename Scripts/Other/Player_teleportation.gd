extends Area2D

@export var teleport_player_here : Node2D
@export var pos_y : float = -50.0
@export var atk : int = 5

func _ready():
	if !is_instance_valid(teleport_player_here):
		push_error("No location, for teleporting player")

func _on_body_entered(body):
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			body.hit(atk)
			body.global_position = teleport_player_here.global_position+Vector2(0,pos_y)
