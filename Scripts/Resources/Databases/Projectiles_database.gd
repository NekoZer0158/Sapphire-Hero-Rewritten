class_name Projectiles_database
extends Resource

var projectiles : Dictionary = {}

func add_projectiles() -> void:
	var d = DirAccess
	var files = d.get_files_at("res://Scenes/Projectiles/")
	if files.size() > 0:
		for i in files:
			if i.ends_with(".remap"):
				add_new_projectile_scene(load("res://Scenes/Projectiles/"+i.get_slice(".",0)+"."+i.get_slice(".",1)))
			else:
				add_new_projectile_scene(load("res://Scenes/Projectiles/"+i))
	else:
		push_error("This directiory doesn't exists")

func add_new_projectile_scene(new_projectile:PackedScene) -> void:
	var p := new_projectile.instantiate()
	projectiles[p.id] = new_projectile

func add_new_projectile(new_projectile:Projectile) -> void:
	if not new_projectile.id in projectiles.keys():
		projectiles[new_projectile.id] = new_projectile
	else:
		push_warning("A projectile with this id was already added")

func clear() -> void:
	projectiles.clear()
