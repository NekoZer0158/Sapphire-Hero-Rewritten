class_name Enemy_boom
extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	boom()

func boom() -> void:
	animated_sprite_2d.play("default")

func _on_animated_sprite_2d_animation_finished():
	queue_free()
