class_name Boss_AI
extends Node2D

@onready var boss_body : Robot_body = $Boss_body
@onready var boss_UI : Boss_UI = $Boss_UI/Boss_UI

var phase : int = 0
var activated : bool = false

signal activated_boss()
signal end_level

func _ready():
	if !is_instance_valid(boss_body):
		push_error("No boss_body")
	else:
		GlobalSapphire.cur_boss = self
		boss_body.type = GlobalEnum.BodyTypes.ENEMY
	start()

func start() -> void:
	pass

func _physics_process(_delta):
	if activated:
		check_if_needed_to_change_state()
		check_boss_state()

func check_boss_state() -> void:
	pass

func check_if_needed_to_change_state() -> void:
	pass

func activate_boss() -> void:
	activated = true
	emit_signal("activated_boss")
	boss_UI.show()

func _boss_death():
	emit_signal("end_level")
	queue_free()
