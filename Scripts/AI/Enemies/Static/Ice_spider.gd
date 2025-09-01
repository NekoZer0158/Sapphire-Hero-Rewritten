class_name Ice_spider
extends Static_Robot_body

@onready var raycast : RayCast2D = $RayCast2D
@onready var ice_spike : Projectile = $Ice_spike

var activated : bool = false

func start() -> void:
	type = GlobalEnum.BodyTypes.ENEMY
	ice_spike.type = GlobalEnum.BodyTypes.ENEMY

func _physics_process(_delta):
	if !activated:
		if raycast.get_collider() is Moving_body:
			if raycast.get_collider().type == GlobalEnum.BodyTypes.PLAYER:
				use_ice_spike()

func use_ice_spike() -> void:
	if !activated:
		if is_instance_valid(ice_spike):
			var ice_spike_pos : Vector2 = ice_spike.global_position
			activated = true
			remove_child(ice_spike)
			get_parent().add_child(ice_spike)
			ice_spike.global_position = ice_spike_pos
			ice_spike.activated = true
		else:
			push_warning("no ice_spike")
