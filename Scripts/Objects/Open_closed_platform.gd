class_name Open_closed_platform
extends Node2D

@export var pos_when_closed : int = 100

@onready var left = $Left
@onready var right = $Right
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.get_animation("open_close").track_set_key_value(0,1,Vector2(animation_player.get_animation("open_close").track_get_key_value(0,0).x-pos_when_closed,0))
	animation_player.get_animation("open_close").track_set_key_value(1,1,Vector2(animation_player.get_animation("open_close").track_get_key_value(1,0).x+pos_when_closed,0))
	animation_player.play("open_close")


func _on_boss_activation_player_entered():
	animation_player.play_backwards("open_close")
