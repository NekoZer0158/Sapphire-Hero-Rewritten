class_name Breakable_box
extends StaticBody2D

@export var cur_frame : int = 0
@export var boom : PackedScene

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var boom_pos : Marker2D = $Marker2D
@onready var area_2d: Area2D = $Area2D

var body_below: Breakable_box

func _ready() -> void:
	sprite_2d.frame = cur_frame
	await get_tree().create_timer(0.2,false).timeout
	$Area2D/CollisionShape2D.disabled = false

func hit(projectile_id:int) -> void:
	if projectile_id == 10:
		spawn_boom_effect()
		if is_instance_valid(body_below):
			if body_below.sprite_2d.frame%2 != 0:
				body_below.sprite_2d.frame -= 1
		queue_free()

func spawn_boom_effect() -> void:
	var spawn_this = boom.instantiate()
	spawn_this.global_position = boom_pos.global_position/4
	get_parent().add_child(spawn_this)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Breakable_box:
		body.sprite_2d.frame += 1
		body_below = body
		area_2d.queue_free()
