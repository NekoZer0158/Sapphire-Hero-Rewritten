class_name Hack_planes_Player
extends Hack_planes_Plane

var cur_movement : Vector2

func start() -> void:
	if "Plane" in GlobalSapphire.customization_data.customization_info.keys():
		$Sprite2D.texture = load("res://Sprites/Minigames/Hack_planes/Player/"+GlobalSapphire.customization_data.customization_info["Plane"]+"/Plane.png")

func controls() -> void:
	cur_movement = Input.get_vector("Left","Right","Up","Down")
	if abs(cur_movement.x) < 0.5:
		cur_movement.x = 0
	if abs(cur_movement.y) < 0.5:
		cur_movement.y = 0
	cur_movement *= speed
	if Input.is_action_pressed("Shoot"):
		shoot()
	movement_x(cur_movement.x)
	movement_y(cur_movement.y)
