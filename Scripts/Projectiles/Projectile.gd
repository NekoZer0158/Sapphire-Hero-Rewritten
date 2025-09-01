class_name Projectile
extends Node2D

@export var id : int ## must be unique for every projectile
@export var atk : int
@export var speed : Vector2
@export var life_time : float
@export var life_timer : Timer
@export var activated : bool = true
@export_group("Particles")
@export var has_particle : bool = true
@export_color_no_alpha var particle_color : Color = Color.WHITE

var type : GlobalEnum.BodyTypes
var particle : PackedScene = preload("res://Scenes/Effects/Projectiles/Default_weapon_particle.tscn")

func _ready():
	if life_time > 0:
		if is_instance_valid(life_timer):
			life_timer.start(life_time)
		else:
			push_error("No life timer")
	start()

func start() -> void:
	pass

func _physics_process(delta):
	if activated:
		position += speed * delta

func _on_timer_life_timeout():
	queue_free()

func spawn_particle() -> void:
	if particle != null:
		var new_particle = particle.instantiate()
		new_particle.global_position = global_position
		new_particle.modulate = particle_color
		new_particle.emitting = true
		new_particle.amount = new_particle.amount+randi_range(-1,1)
		new_particle.look_at(global_position+speed)
		get_parent().add_child(new_particle)

func _on_area_2d_body_entered(body):
	if body is Robot_body or body is Static_Robot_body or body is Robot_spawner:
		if body.type != type and not body.type in GlobalSapphire.type_friendlists[type]:
			if "hit_including_projectile" in body:
				body.hit_extended(atk,self)
				if body is Robot_body or body is Static_Robot_body:
					spawn_particle()
			else:
				body.hit(atk)
				if has_particle:
					spawn_particle()
			queue_free()
	else:
		queue_free()
