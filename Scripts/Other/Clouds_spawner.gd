class_name Clouds_spawner
extends Area2D

@export var spawn_clouds_instantly : bool = false
@export var amount_of_clouds : int = 0
@export var cloud_spawning_time : float = 1.0
@export var clouds : Array[PackedScene]
@export var clouds_min_and_max_speed : Vector2
@export var new_cloud_scale : float = 1.0
@export var new_modulate : Color = Color.WHITE
@export var new_z_index : int = 0
@export var divider : int = 8

@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var timer : Timer = $Timer
var cur_amount_of_clouds : int = 0
@export var parent_node : Node

func _ready():
	randomize()
	if !is_instance_valid(parent_node):
		push_error("No parent_node")
		queue_free()
	if !check_scenes():
		push_error("There is scene, that is not a cloud")
		queue_free()
	if cloud_spawning_time > 0:
		if !is_instance_valid(timer):
			push_error("There is no timer")
			queue_free()
		else:
			timer.start(cloud_spawning_time)
	if spawn_clouds_instantly:
		for i in range(0,amount_of_clouds):
			spawn_cloud()
		queue_free()

func spawn_cloud() -> void:
	if cur_amount_of_clouds < amount_of_clouds:
		var cur_cloud = clouds[randi_range(0,clouds.size()-1)].instantiate()
		cur_cloud.speed = randf_range(clouds_min_and_max_speed.x,clouds_min_and_max_speed.y-1)
		cur_cloud.sprite.frame = randi_range(0,cur_cloud.sprite.hframes*cur_cloud.sprite.vframes-1)
		cur_cloud.global_position = Vector2(randf_range(collision_shape.global_position.x/4-collision_shape.shape.size.x/divider,collision_shape.shape.size.x/divider+(collision_shape.global_position.x-1)/4),randf_range(collision_shape.global_position.y/4-collision_shape.shape.size.y/divider,collision_shape.shape.size.y/divider+(collision_shape.global_position.y-1)/4))
		cur_cloud.scale *= new_cloud_scale
		cur_cloud.modulate = new_modulate
		cur_cloud.z_index = new_z_index
		cur_amount_of_clouds += 1
		parent_node.call_deferred("add_child",cur_cloud)

func check_scenes() -> bool:
	var loaded_cloud
	for i in clouds:
		loaded_cloud = i.instantiate()
		if not loaded_cloud is Cloud:
			return false
		loaded_cloud.queue_free()
	return true


func _on_timer_timeout():
	spawn_cloud()

func _removed_cloud() -> void:
	cur_amount_of_clouds -= 1
	if cur_amount_of_clouds <= -50:
		cur_amount_of_clouds = -50
