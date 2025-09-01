@icon("res://Sprites/Icons/Checkpoint.svg")
class_name Checkpoint
extends Node2D

@onready var sprite_node : Sprite2D = $Sprite2D
@onready var label_node : Label = $Label
@onready var player_pos : Marker2D = $Marker2D
@export var cur_checkpoint : int = 0
@export var block_this_doors : Array[Door] = []

func _on_area_2d_body_entered(body):
	if body is Moving_body and visible:
		if body.type == GlobalEnum.BodyTypes.PLAYER:
			GlobalSapphire.cur_hp_refills = body.hp_refills
			if body.get_parent().ammo_regeneration:
				for i in range(0,body.ammo.size()):
					body.ammo[i].x = body.shooting_module.weapons[i].max_ammo
			else:
				GlobalSapphire.cur_ammo = body.ammo.duplicate(true)
			sprite_node.modulate = body.body_sprite.material["shader_parameter/change_only_with_this_color"]
			#sprite_node.modulate = Color.DODGER_BLUE-Color(0.1,0.1,0.1,0)
			label_node.modulate = Color.WHITE
			GlobalSapphire.cur_checkpoint = cur_checkpoint
			for i in block_this_doors:
				i.can_door_open = false
