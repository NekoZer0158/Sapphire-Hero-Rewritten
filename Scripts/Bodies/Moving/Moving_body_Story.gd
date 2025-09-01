extends Moving_body_extended

@onready var sword_right = $Body/Arm_right/Hand/Sword
@onready var sword_left = $Body/Arm_left/Hand_shoot/Sword

func activate_swords() -> void:
	sword_left.show()
	sword_right.show()
