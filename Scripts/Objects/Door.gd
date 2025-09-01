@icon("res://Sprites/Icons/Door.svg")
class_name Door
extends Node2D

@export var id : int
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@export var can_door_open : bool = true
@export_group("DO NOT TOUCH")
@export var door_opened : bool = false

var bodies_around : Array[Moving_body]

func _physics_process(_delta):
	if !animation_player.is_playing() and can_door_open:
		if !door_opened and bodies_around.size() > 0:
			animation_player.play("open_close")
		elif door_opened and bodies_around.size() == 0:
			animation_player.play_backwards("open_close")
	elif !can_door_open and door_opened:
		if !animation_player.is_playing():
			animation_player.play_backwards("open_close")

func _on_area_2d_body_entered(body):
	if body is Moving_body:
		bodies_around.append(body)

func _on_area_2d_body_exited(body):
	if body is Moving_body:
		if body in bodies_around:
			bodies_around.erase(body)
