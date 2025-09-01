extends CharacterBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	move_and_slide()
	if !is_on_floor() and !collision_shape_2d.disabled:
		velocity.y += gravity * delta
	elif !collision_shape_2d.disabled:
		collision_shape_2d.set_deferred("disabled",true)
