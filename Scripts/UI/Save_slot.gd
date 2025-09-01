class_name Save_slot
extends Control

@onready var save_slot_colorrect : ColorRect = $ColorRect
@onready var save_number := $save_number_border/Save_number
@onready var boss_heads := $Boss_heads
#No savedata
@onready var no_save_data: Control = $No_save_data
@onready var main_save_data: NinePatchRect = $No_save_data/Main
@onready var sprite_2d_save_data: Sprite2D = $No_save_data/Sprite2D
@onready var color_rect_save_data: ColorRect = $No_save_data/ColorRect
# Boss heads
@onready var boss_kostyanoy := $Boss_heads/Boss_Kostyanoy
@onready var boss_ledyanoy := $Boss_heads/Boss_Ledyanoy
@onready var boss_unknown := $Boss_heads/Boss_Unknown
@onready var boss_zeppelin := $Boss_heads/Boss_Zeppelin
@onready var boss_final := $Final_boss_border/Sprite2D

@onready var final_boss_label := $Final_boss_border/Label
@onready var hp_refills_label := $HP_refills/Label
@onready var mobile_node: Control = $Mobile
@onready var dimension_label: Label = $Dimension
@export_color_no_alpha var color : Color
@export var number : int = 0

var selectable_borders : Array[NinePatchRect] = []
var cur_dimension : int = 1:
	set(value):
		cur_dimension = clamp(value,1,2)
		match cur_dimension:
			1:
				boss_unknown.change_head_texture()
			2:
				boss_unknown.change_head_texture(VORONOY_HEAD)

const VORONOY_HEAD = preload("res://Sprites/Boss/Voronoy/Head.png")

func _ready():
	randomize()
	if !OS.has_feature("mobile"):
		mobile_node.queue_free()
	else:
		mobile_node.show()
		dimension_label.hide()
	for i in get_children():
		if i is NinePatchRect:
			if i.name != "Final_boss_border":
				change_color(i,Color.WHITE)
				selectable_borders.append(i)
			else:
				change_color(i,color*0.25)
				for j in i.get_children():
					if j is ColorRect:
						change_color(j,color)
	for i in boss_heads.get_children():
		for j in i.get_children():
			if j is NinePatchRect:
				change_color(j,color*0.25)
	save_slot_colorrect.self_modulate = color
	save_number.text = TranslationServer.translate("save_")+" "+str(number)
	randomize_heads()

func translate_save_() -> void:
	save_number.text = TranslationServer.translate("save_")+" "+str(number)

func select_border(active_color:Color) -> void:
	for i in selectable_borders:
		change_color(i,active_color)

func change_color(change_color_for_this:Node,new_color:Color)-> void:
	if change_color_for_this is ColorRect:
		change_color_for_this.color = new_color
	else:
		change_color_for_this.self_modulate = new_color
		change_color_for_this.self_modulate.a = 1
	for j in change_color_for_this.get_children():
		if j is ColorRect:
			j.color = color

func set_no_savedata() -> void:
	no_save_data.show()
	main_save_data.self_modulate = color
	sprite_2d_save_data.self_modulate = color
	color_rect_save_data.color = color*0.25

func randomize_heads() -> void:
	for i in boss_heads.get_children():
		boss_heads.move_child(i,randi_range(0,boss_heads.get_child_count()))

func change_dimension(increase_by:int) -> void:
	cur_dimension += increase_by
	match cur_dimension:
		1:
			dimension_label.text = "  M>"
		2:
			dimension_label.text = "<A1 "

func hide_changeable_dimension() -> void:
	match cur_dimension:
		1:
			dimension_label.text = "  M "
		2:
			dimension_label.text = " A1 "

func set_data_for_the_slot(save_data:Savedata) -> bool:
	if number == save_data.save_number:
		if save_data.completed_levels["Kostyanoy"] == 1:
			boss_kostyanoy.make_head_black_and_white()
		if save_data.completed_levels["Ledyanoy"] == 1:
			boss_ledyanoy.make_head_black_and_white()
		if save_data.completed_levels["Zeppelin"] == 1:
			boss_zeppelin.make_head_black_and_white()
		if save_data.completed_levels["Unknown"] == 1:
			boss_unknown.make_head_black_and_white()
		if save_data.completed_levels["Kostyanoy"] == 1 and save_data.completed_levels["Ledyanoy"] == 1 and save_data.completed_levels["Zeppelin"] == 1 and save_data.completed_levels["Unknown"] == 1:
			final_boss_label.hide()
			boss_final.frame = 1
		if save_data.completed_levels["Black_Baron"] == 1:
			boss_final.frame = 2
			boss_final.material["shader_parameter/activated"] = true
		cur_dimension = save_data.dimension
		var hp_refills : int = 0
		for i in save_data.player_hp_refills.keys():
			if save_data.player_hp_refills[i] == 1:
				hp_refills += 1
			hp_refills_label.text = "="+str(hp_refills)
		return true
	push_error("Different save numbers")
	return false
