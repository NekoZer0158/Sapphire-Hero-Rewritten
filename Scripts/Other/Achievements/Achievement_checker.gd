class_name Achievement_checker
extends Node2D

@export var achievement_name : String

var achievement_texture : Texture
var achievement_started : bool = false
var data_to_check : Dictionary

signal got_achievement(name_of_achievement,achievement_texture)

func _ready() -> void:
	achievement_texture = load("res://Sprites/UI/Achievements/"+achievement_name+".png")

func start_achievement(_args:Array) -> void:
	achievement_started = true

func check_if_completed(_args:Array) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			start_achievement([])

func _on_area_2d_end_body_entered(body: Node2D) -> void:
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			check_if_completed([]) 
