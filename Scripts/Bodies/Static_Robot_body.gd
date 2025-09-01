class_name Static_Robot_body
extends StaticBody2D

@export var hp : int = 100
@export var def : int = 0
@export var reload_time : float
@export var shooting_module : Shooting_module
@export var markers : Array[Marker2D]
@export var timer_reload : Timer
@export var death_effect_marker : Marker2D
# Weapon
var can_use_weapon : bool = true
var cur_weapon : int = 0

@export var type : GlobalEnum.BodyTypes
var dead : bool = false

var death_effect : PackedScene = preload("res://Scenes/Effects/Enemy_boom.tscn")

var mod_nodes_and_resources : Dictionary

signal got_hit(new_hp:int)
signal reload_ended()
signal now_dead()

func _ready():
	start()

func start() -> void: ## I didn't know about super() when I wrote this (at least that I can use ti for _ready())
	pass

func movement(cur_direction:float,_other_args:Array=[]) -> void:
	var direction = cur_direction
	change_direction(direction)

func shoot() -> void:
	if shooting_module != null:
		shoot_animation()
		if can_use_weapon:
			if shooting_module.use_module([markers,cur_weapon,scale.y,type]):
				can_use_weapon = false
				if is_instance_valid(timer_reload):
					timer_reload.start(reload_time)
				else:
					push_error("no timer_reload")

func shoot_animation() -> void:
	pass

func hit(dmg : int) -> void:
	if dmg > def:
		hp -= dmg-def
		emit_signal("got_hit",hp)
		if hp <= 0 and !dead:
			death()

func death() -> void:
	dead = true
	emit_signal("now_dead")
	var spawn_death_effect = death_effect.instantiate()
	spawn_death_effect.position = death_effect_marker.global_position/4
	get_parent().get_parent().add_child(spawn_death_effect)
	get_parent().queue_free()

func change_direction(cur_direction:float) -> void:
	if cur_direction < 0:
		scale.y = -1
		rotation_degrees = 180
	elif cur_direction > 0:
		scale.y = 1
		rotation_degrees = 0

func _on_timer_reload_timeout():
	can_use_weapon = true
	emit_signal("reload_ended")
