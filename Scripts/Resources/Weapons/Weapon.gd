class_name Weapon
extends Resource

@export var weapon_name : String = "No_name"
@export var weapon_id : int = 0 ## only used for the player to play proper sound effect
@export var max_ammo : int = 0 ## if set to -1, the ammo is infinite
@export var ammo_per_shot : int = 0 ## ammos, that will be used for one shot
@export var projectile_ids : Array[int] ## used projectiles ids
@export var min_amount_of_markers : int ## from those markers, projecties will be shot

func use_weapon(_markers:Array[Marker2D],_direction:float,_type:GlobalEnum.BodyTypes) -> void:
	pass

func set_projectile(projectile:Projectile,marker:Marker2D,direction:float,type:GlobalEnum.BodyTypes) -> void:
	projectile.type = type
	projectile.position = marker.global_position
	projectile.speed *= direction
	projectile.scale *= direction
	GlobalSapphire.add_child(projectile)
