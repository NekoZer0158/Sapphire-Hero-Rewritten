class_name Robot_spawner
extends StaticBody2D

@export var spawn_this_robot : PackedScene
@export var robots_limit : int = 3

@onready var marker_up = $Spawn_positions/Up
@onready var marker_right = $Spawn_positions/Right
@onready var marker_down = $Spawn_positions/Down
@onready var marker_left = $Spawn_positions/Left

var robots : Array[Node2D]
var cur_marker : Marker2D = null
var type := GlobalEnum.BodyTypes.ENEMY

func hit(_atk:int) -> void:
	spawn_robot(cur_marker.global_position)

func spawn_robot(spawn_pos:Vector2) -> void:
	if check_array():
		var new_robot = spawn_this_robot.instantiate()
		new_robot.global_position = spawn_pos/4
		get_parent().call_deferred("add_child",new_robot)
		robots.append(new_robot)

func check_array() -> bool:
	var erase_element : bool = false
	var remove_elem_at : int = 0
	if robots.size() < robots_limit:
		return true
	for i in range(0,robots.size()):
		if !is_instance_valid(robots[i]):
			remove_elem_at = i
			erase_element = true
			break
	if erase_element:
		robots.remove_at(remove_elem_at)
		return true
	return false

func check_area_parent(area) -> bool:
	var area_parent = area.get_parent()
	if area_parent != null:
		if area_parent is Projectile:
			return true
	return false

func _on_area_2d_up_area_entered(area):
	if check_area_parent(area):
		cur_marker = marker_up

func _on_area_2d_down_area_entered(area):
	if check_area_parent(area):
		cur_marker = marker_down

func _on_area_2d_right_area_entered(area):
	if check_area_parent(area):
		cur_marker = marker_right

func _on_area_2d_left_area_entered(area):
	if check_area_parent(area):
		cur_marker = marker_left
