class_name Cloud
extends Node2D

var speed : float
@export var sprite : Sprite2D
	
func _physics_process(delta):
	position.x += speed*delta
