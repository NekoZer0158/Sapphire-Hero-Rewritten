class_name Final_Boss_activation
extends Node2D

@export var boss_phase_1 : Flying_body
@export var close_this_door : Door
@export var parent_node : Node2D

@onready var boss_ui = $Boss_UI/Boss_UI
@onready var phase = $Boss_UI/Boss_UI/Phase

var boss_phase_2 = preload("res://Scenes/Boss/Black_Baron/Black_Baron_phase_2.tscn")
var boss_phase_3 = preload("res://Scenes/Boss/Black_Baron/Black_Baron_phase_3.tscn")
var boss_phase_3_destroyed = preload("res://Scenes/Bodies/Boss/Black_Baron_phase_3_destroyed.tscn")
var b1_global_pos : Vector2

var activated : bool  = false

signal player_entered()

func _ready():
	if !is_instance_valid(boss_phase_1):
		push_error("There is no boss_1")
	else:
		boss_ui.boss_body = boss_phase_1
	#if !is_instance_valid(boss_phase_2):
		#push_error("There is no boss_phase_2")
	#if !is_instance_valid(boss_phase_3):
		#push_error("There is no boss_phase_3")
	if !is_instance_valid(close_this_door):
		push_error("There is no door")

func _physics_process(_delta):
	if is_instance_valid(boss_phase_1):
		b1_global_pos = boss_phase_1.global_position

func activate_boss(player_body:Player):
	if is_instance_valid(player_body):
		set_camera_limit(player_body.player_camera)
		if is_instance_valid(boss_phase_1):
			boss_phase_1.activated = true
		close_this_door.can_door_open = false
		boss_ui.show()
	else:
		push_error("No player_body")

func _on_area_2d_body_entered(body):
	if body is Moving_body:
		if body.type == GlobalEnum.BodyTypes.PLAYER and !activated:
			activated = true
			emit_signal("player_entered")
			activate_boss(body.get_parent())

func set_camera_limit(_camera_node:Camera2D):
	pass

func spawn_phase_2() -> void:
	var b2 = boss_phase_2.instantiate()
	b2.global_position = b1_global_pos/4
	b2.boss_UI = boss_ui
	b2.main_node = self
	b2.change_ui()
	b2.now_boss_dead.connect(_on_black_baron_phase_2_now_dead)
	get_parent().call_deferred("add_child",b2)
	boss_ui.set_boss_hp(15,boss_ui.boss_HP_color)

func spawn_phase_3(bp2_pos:Vector2) -> void:
	var b3 = boss_phase_3.instantiate()
	b3.global_position = bp2_pos/4
	b3.boss_UI = boss_ui
	b3.main_node = self
	b3.change_ui()
	b3.now_boss_dead.connect(_on_black_baron_phase_3_now_dead)
	get_parent().call_deferred("add_child",b3)
	boss_ui.set_boss_hp(15,boss_ui.boss_HP_color)
	
func spawn_phase_3_destroyed(bp3_pos:Vector2) -> void:
	var b3 = boss_phase_3_destroyed.instantiate()
	b3.global_position = bp3_pos/4
	b3.type = GlobalEnum.BodyTypes.ENEMY
	get_parent().call_deferred("add_child",b3)
	if is_instance_valid(GlobalSapphire.player):
		if is_instance_valid(GlobalSapphire.player.player_body):
			if GlobalSapphire.player.player_body.global_position.x/4 < b3.global_position.x:
				b3.scale.y = -1
				b3.rotation_degrees = -180
			parent_node._end_level()

func _on_black_baron_phase_1_now_dead():
	spawn_phase_2()
	phase.frame = 1

func _on_black_baron_phase_2_now_dead(global_pos:Vector2):
	spawn_phase_3(global_pos)
	phase.frame = 2

func _on_black_baron_phase_3_now_dead(global_pos:Vector2):
	spawn_phase_3_destroyed(global_pos)
	boss_ui.hide()
