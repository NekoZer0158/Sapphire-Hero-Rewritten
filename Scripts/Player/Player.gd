class_name Player
extends Node2D

@export var player_body : Moving_body
@export var player_UI : Player_UI
@export var player_camera : Camera2D
@export var activation_button : Button_UI
@export var timer_after_death : Timer
@export var time_before_restart : float = 1.0
@export var transition_time : float = 0.7
@export_color_no_alpha var default_color : Color
@export_group("Ammo Regeneration")
@export var ammo_regeneration : bool = false
@export var timer_ammo : Timer
@export var time_for_ammo_regeneration : float
@export_group("Sound")
@export var sounds : Array[AudioStream]

@onready var teleport_transition = $UI/Teleport_transition
@onready var transition = $Transition/Transition
@onready var audio_stream_player_sound = $AudioStreamPlayer_sound
@onready var player_head = $PlayerBody/Body/Head

var can_activate : bool = false
var can_control_player : bool = true
var object_activation : Activate_object
var can_teleport : bool = true
var activated: bool = false
var player_body_position : Vector2
var epilogue : bool = false
var mobile_activate_button : TouchScreenButton

const teleport_transition_time : float = 0.5

signal please_restart_a_level()

func _ready():
	var mobile_controls_node : Mobile_controls
	player_body.type = GlobalEnum.BodyTypes.PLAYER
	player_camera.reset_smoothing()
	if OS.has_feature("mobile"):
		var new_canvas_layer := CanvasLayer.new()
		mobile_controls_node = load("res://Scenes/Player/Mobile_controls.tscn").instantiate()
		new_canvas_layer.layer = 5
		add_child(new_canvas_layer)
		mobile_activate_button = mobile_controls_node.get_node("Right_controls/TouchScreenButton_activate")
		new_canvas_layer.add_child(mobile_controls_node)
	if ammo_regeneration:
		if OS.has_feature("mobile"):
			set_everything_for_mobile_version(mobile_controls_node)
		if is_instance_valid(timer_ammo):
			timer_ammo.start()
	if is_instance_valid(player_head):
		const MODS_HEADS_NAMES : Array[String] = ["Head_1","Head_2","Head_3"]
		if not GlobalSapphire.customization_data.customization_info["Head"] in MODS_HEADS_NAMES:
			player_head.texture = load("res://Sprites/Player/"+GlobalSapphire.customization_data.customization_info["Head"]+"/Head.png")
		else:
			player_head.texture = Custom_textures_loader.load_one_texture(OS.get_executable_path().get_base_dir()+"/Mods/Heads",GlobalSapphire.customization_data.customization_info["Head"]+".png")
	while player_body.shooting_module.weapons.size() > 1:
		player_body.shooting_module.weapons.erase(player_body.shooting_module.weapons.back())
	player_body.ammo.clear()
	for i in player_body.shooting_module.weapons:
		player_body.ammo.append(Vector2i(i.max_ammo,i.max_ammo))
	GlobalSapphire.player = self
	player_UI.set_everything(self)
	if GlobalSapphire.player_savedata != null:
		check_completed_levels()
	AudioServer.set_bus_volume_db(1,GlobalSapphire.min_audio_value+GlobalSapphire.sound_level*4)
	if OS.has_feature("mobile"):
		mobile_controls_node.player_body = player_body
		mobile_controls_node.player_UI = player_UI
	await get_tree().create_timer(0.7).timeout
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(transition,"modulate",Color(0.0,0.0,0.0,0.0),transition_time)
	await new_tween.finished
	activated = true

func set_everything_for_mobile_version(mobile_controls_node:Mobile_controls) -> void:
	mobile_controls_node.activated_texture_move = load("res://Sprites/Other/Mobile/Move_activated_upgrade.png")
	mobile_controls_node.activated_texture_shoot = load("res://Sprites/Other/Mobile/Shoot_activated_upgrade.png")
	mobile_controls_node.activated_texture_jump = load("res://Sprites/Other/Mobile/Jump_activated_upgrade.png")
	mobile_controls_node.activated_texture_activate = load("res://Sprites/Other/Mobile/Activate_activated_upgrade.png")
	mobile_controls_node.activated_texture_weapon = load("res://Sprites/Other/Mobile/Weapon_change_activated_upgrade.png")
	mobile_controls_node.activated_texture_pause = load("res://Sprites/Other/Mobile/Pause_activated_upgrade.png")
	mobile_controls_node.activated_texture_hp_refill = load("res://Sprites/Other/Mobile/HP_refill_activated_upgrade.png")
	mobile_controls_node.change_activated_textures()
	player_UI.pause_UI.mobile_node.get_node("TSB_restart").texture_pressed = load("res://Sprites/Other/Mobile/Pause_UI/Restart_activated_upgrade.png")
	player_UI.pause_UI.mobile_node.get_node("TSB_back_to_menu").texture_pressed = load("res://Sprites/Other/Mobile/Pause_UI/Btm_activated_upgrade.png")
	player_UI.pause_UI.mobile_node.get_node("TSB_settings").texture_pressed = load("res://Sprites/Other/Mobile/Shoot_activated_upgrade.png")

func check_completed_levels() -> void:
	if GlobalSapphire.player_savedata.completed_levels["Unknown"] == 1:
		if GlobalSapphire.player_savedata.dimension == 1:
			add_new_weapon("Triple_weapon")
		else:
			add_new_weapon("Voronoy_weapon")
	if GlobalSapphire.player_savedata.completed_levels["Kostyanoy"] == 1:
		add_new_weapon("Double_scythe")
	if GlobalSapphire.player_savedata.completed_levels["Ledyanoy"] == 1:
		add_new_weapon("Power_punch")
	if GlobalSapphire.player_savedata.completed_levels["Zeppelin"] == 1:
		add_new_weapon("Zeppelin_weapon")
	
func add_new_weapon(weapon_name:String) -> void:
	var new_weapon := load("res://Resources/Weapons/"+weapon_name+".tres")
	if not new_weapon in player_body.shooting_module.weapons:
		player_body.shooting_module.weapons.append(new_weapon)
		player_body.ammo.append(Vector2i(new_weapon.max_ammo,new_weapon.max_ammo))

func _physics_process(_delta):
	if is_instance_valid(player_body) and activated:
		player_body_position = player_body.global_position
		if player_body.scale.y != activation_button.scale.y:
			if player_body.scale.y == -1:
				activation_button.scale.y = -1
				activation_button.rotation_degrees = 180
			else:
				activation_button.scale.y = 1
				activation_button.rotation_degrees = 0
		if can_control_player:
			player_body.movement(Input.get_axis("Left", "Right"))
			if Input.is_action_just_pressed("Jump"):
				player_body.jump(true)
			if Input.is_action_pressed("Shoot"):
				player_body.shoot()
			if Input.is_action_just_pressed("Next_weapon"):
				player_body.change_weapon(1)
			if Input.is_action_just_pressed("Previous_weapon"):
				player_body.change_weapon(-1)
			if Input.is_action_just_pressed("Use_hp_refill") and player_body.hp < 15:
				player_body.refill_hp()
		else:
			player_body.movement(0.0)
		if Input.is_action_just_pressed("Activate"):
			if is_instance_valid(object_activation):
				object_activation.activate(player_body)

func use_teleport_transition(alpha:float,unique_time:float=0.0) -> bool:
	var new_tween = get_tree().create_tween()
	if unique_time < 0.1:
		new_tween.tween_property(teleport_transition,"self_modulate",Color(0.0,0.0,0.0,alpha),teleport_transition_time)
	else:
		new_tween.tween_property(teleport_transition,"self_modulate",Color(0.0,0.0,0.0,alpha),unique_time)
	await new_tween.finished
	return true

func enable_activation(object:Activate_object) -> void:
	can_activate = true
	object_activation = object
	if !GlobalSapphire.mobile_version:
		if Input.get_connected_joypads().size() > 0:
			var joy_name := Input.get_joy_name(0)
			if "PS3" in joy_name or "PS4" in joy_name or "PS5" in joy_name or "PS6" in joy_name:
				activation_button.cur_button = "[center][img=8]Sprites/UI/Controls/Triangle.png[/img]"
			else:
				activation_button.cur_button = "[center]Y"
			activation_button.set_button_text()
		else:
			activation_button.cur_button = "[center]R"
			activation_button.set_button_text()
		activation_button.show()
	else:
		mobile_activate_button.show()

func disable_activation() -> void:
	can_activate = false
	object_activation = null
	if !GlobalSapphire.mobile_version:
		activation_button.hide()
	else:
		mobile_activate_button.hide()

func _on_player_body_now_dead():
	#player_camera.limit_left = int(player_body_position.x-1920)
	timer_after_death.start(time_before_restart)
	player_camera.reset_smoothing()
	player_camera.limit_smoothed = false
	player_camera.position_smoothing_enabled = false
	player_body.remove_child(player_camera)
	add_child(player_camera)
	player_camera.global_position = player_body_position

func _on_timer_ammo_timeout():
	player_body.ammo_change(1,1)

func _on_timer_after_death_timeout():
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(transition,"modulate",Color(0.0,0.0,0.0,1.0),transition_time)
	await new_tween.finished
	emit_signal("please_restart_a_level")

func _on_player_body_use_weapon(_new_amount_of_ammo):
	if is_instance_valid(player_body):
		if player_body.shooting_module.weapons[player_body.cur_weapon].weapon_id == 2 or player_body.shooting_module.weapons[player_body.cur_weapon].weapon_id == 25:
			if audio_stream_player_sound.stream != sounds[0]:
				audio_stream_player_sound.stream = sounds[0]
			audio_stream_player_sound.play()
