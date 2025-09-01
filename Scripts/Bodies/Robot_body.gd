class_name Robot_body
extends CharacterBody2D

@export var hp : int = 100
@export var def : int = 0
@export var speed : float = 300.0
@export var reload_time : float
@export var shooting_module : Shooting_module
@export var markers : Array[Marker2D] ## From those markers projectiles will be shot
@export var body_sprite : Sprite2D
@export var death_effect_marker : Marker2D

@export_group("Timers")
@export var timer_reload : Timer
@export var timer_immortality_frames : Timer

@export_group("Extra")
@export var infinite_ammo : bool = false
@export var immortality_frames : bool = false
@export var mirror_sprite : bool = true ## sprite will be mirrored when moving the other direction
@export var can_change_color : bool = false
@export var immortal : bool = false
@export var has_death_effect : bool = true
@export var unique_death_effect_path : String
@export var can_change_weapon : bool = false
@export var body_resources : Dictionary[String,Resource] ## some code is in resources, instead of being here, removing unnecessary code from here

var max_hp : int
# Weapon
var can_use_weapon : bool = true
var ammo : Array[Vector2i] = []
var cur_weapon : int = 0

var type : GlobalEnum.BodyTypes
var immortality : bool = false
var dead : bool = false
var hp_refills : int = 0
var death_effect : PackedScene = preload("res://Scenes/Effects/Enemy_boom.tscn")
var mod_nodes_and_resources : Dictionary

var default_color : Color

const immortality_time : float = 0.75

signal got_hit(new_hp:int)
signal use_weapon(new_amount_of_ammo:int)
signal ammo_changed(new_amount_of_ammo:int)
signal hp_refill_change(new_hp_refill:int)
signal weapon_changed(new_weapon:Weapon,ammo_for_weapon:int)
signal now_dead()

func _ready():
	var parent_node = get_parent()
	max_hp = hp
	if unique_death_effect_path != "":
		death_effect = load(unique_death_effect_path)
	if mirror_sprite:
		body_resources["Body_change_direction"] = Body_change_direction.new()
		body_resources["Body_change_direction"].check_parent_node_scale_y(parent_node,self)
	if shooting_module != null:
		body_resources["Body_shooting"] = Body_shooting.new()
		if ammo.size() == 0:
			for i in shooting_module.weapons:
				ammo.append(Vector2i(i.max_ammo,i.max_ammo))
	if can_change_color:
		if body_sprite.material != null:
			default_color = body_sprite.material["shader_parameter/color"]
		else:
			push_error("there is no material in body_sprite")
	if can_change_weapon:
		body_resources["Body_weapon_change"] = Body_weapon_change.new()
		change_weapon(0)
	start()

func start() -> void:
	pass

func movement(cur_direction:float,_other_args:Array=[]) -> void:
	var direction = cur_direction
	if mirror_sprite:
		body_resources["Body_change_direction"].change_direction(direction,self)

func refill_hp() -> void:
	if hp_refills > 0:
		hp_refills -= 1
		hp = max_hp
		emit_signal("hp_refill_change",hp_refills)
		emit_signal("got_hit",hp)

func shoot() -> void:
	if shooting_module != null:
		shoot_animation()
		body_resources["Body_shooting"].shooting(self)

func ammo_change(ammo_amount:int,plus_or_minus_ammo:int=-1) -> void:
	if !infinite_ammo and shooting_module.weapons[cur_weapon].max_ammo != -1 and(plus_or_minus_ammo == -1 or ammo[cur_weapon].x < shooting_module.weapons[cur_weapon].max_ammo):
		ammo[cur_weapon].x += ammo_amount*plus_or_minus_ammo
	emit_signal("ammo_changed",ammo[cur_weapon].x)

func change_weapon(new_weapon:int) -> void:
	if can_change_weapon:
		cur_weapon = body_resources["Body_weapon_change"].change_weapon(default_color,new_weapon,cur_weapon,ammo,body_sprite,can_change_color,shooting_module)
	if shooting_module != null:
		emit_signal("weapon_changed",shooting_module.weapons[cur_weapon],ammo[cur_weapon].x)

func shoot_animation() -> void:
	pass

func hit(dmg : int) -> void:
	if dmg > def and !immortal:
		if !immortality:
			hp -= dmg-def
			emit_signal("got_hit",hp)
			if immortality_frames and hp > 0:
				activate_immortality_frames()
		if hp <= 0 and !dead:
			death()

func activate_immortality_frames() -> void:
	immortality = true
	timer_immortality_frames.start(immortality_time)
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(self,"modulate",Color(1.5,1.5,1.5,1),immortality_time/2)
	new_tween.tween_property(self,"modulate",Color(1,1,1,1),immortality_time/2)

func death() -> void:
	dead = true
	emit_signal("now_dead")
	if can_change_color:
		body_resources["Body_weapon_change"].change_color(default_color,body_sprite)
	if has_death_effect:
		if is_instance_valid(death_effect):
			var spawn_death_effect = death_effect.instantiate()
			spawn_death_effect.position = death_effect_marker.global_position/4
			get_parent().get_parent().add_child(spawn_death_effect)
		else:
			push_error("No death_effect when body has_death_effect")
	queue_free()

func _on_timer_reload_timeout():
	can_use_weapon = true

func _on_timer_immortality_timeout():
	immortality = false
