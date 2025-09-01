class_name Shooting_module
extends Module

@export var weapons : Array[Weapon]

func use_module(args:Array) -> bool:
	if args.size() == 4:
		if args[0] is Array[Marker2D] and typeof(args[1]) == TYPE_INT and typeof(args[2]) == TYPE_FLOAT and typeof(args[3]) == TYPE_INT:
			if args[0].size() >= weapons[args[1]].min_amount_of_markers:
				weapons[args[1]].use_weapon(args[0],args[2],args[3])
				return true
			else:
				push_error("Not enough markers")
		else:
			push_error("Wrong args type")
	else:
		push_error("Too many or not enough arguments")
	return false
