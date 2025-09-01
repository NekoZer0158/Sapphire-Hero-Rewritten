extends Node2D

func _ready() -> void:
	var cur_time := Time.get_date_dict_from_system()
	if (cur_time["month"] == Time.Month.MONTH_OCTOBER and cur_time["day"] >= 20) or (cur_time["month"] == Time.Month.MONTH_NOVEMBER and cur_time["day"] <= 2):
		$Sprite2D.texture = load("res://Sprites/Background/Trees/Unknown_trees_halloween.png")
