class_name Pause_UI
extends Control

@export_color_no_alpha var label_shadow_color : Color = Color("4562d6")
@export_color_no_alpha var progress_bar_bg_color : Color = Color("3baaff")
@export var buttons : Array[Button_UI]
@export var time_for_timers : float = 0.08

@onready var progress_bar_restart = $Restart_button/ProgressBar
@onready var progress_bar_back_to_menu = $Back_to_menu/ProgressBar
@onready var settings = $Settings
@onready var restart_desc = $Restart_desc
@onready var timer_restart = $Timer_restart
@onready var timer_back_to_menu = $Timer_back_to_menu
@onready var mobile_node: Control = $Mobile
@onready var btm_desc_label: RichTextLabel = $BtM_desc

var usable : bool = true
var cur_controls : String = "keyboard"

signal restart_a_level()
signal please_back_to_menu()

func _ready():
	for i in buttons:
		i.change_label_shadow_color(label_shadow_color)
	if OS.has_feature("mobile"):
		for i in buttons:
			i.hide()
		$Restart_desc.text = TranslationServer.translate("Restart_desc_m")
		progress_bar_back_to_menu = $Mobile/ProgressBar_btm
		progress_bar_restart = $Mobile/ProgressBar_restart
		btm_desc_label.text = TranslationServer.translate("BtM_desc_m")
		btm_desc_label.position.y = 616
		mobile_node.show()
	else:
		mobile_node.queue_free()
	progress_bar_back_to_menu.theme["ProgressBar/styles/fill"].bg_color = progress_bar_bg_color
	set_controls_for_keyboard()
	check_and_set()

func set_controls_for_keyboard() -> void:
	buttons[0].cur_button = "[center]R"
	buttons[0].set_button_text()
	buttons[1].cur_button = "[center]S"
	buttons[1].set_button_text()
	buttons[2].cur_button = "[center]B"
	buttons[2].set_button_text()
	restart_desc.text = "Restart_desc"
	btm_desc_label.text = "BtM_desc"

func set_controls_for_gamepad_xbox() -> void:
	buttons[0].cur_button = "[center]Y"
	buttons[0].set_button_text()
	buttons[1].cur_button = "[center]A"
	buttons[1].set_button_text()
	buttons[2].cur_button = "[center]B"
	buttons[2].set_button_text()
	restart_desc.text = "Restart_desc_G"
	btm_desc_label.text = "BtM_desc"

func set_controls_for_gamepad_playstation() -> void:
	buttons[0].cur_button = "[center][img=8]Sprites/UI/Controls/Triangle_small.png[/img]"
	buttons[0].set_button_text()
	buttons[1].cur_button = "[center][img=8]Sprites/UI/Controls/X_small.png[/img]"
	buttons[1].set_button_text()
	buttons[2].cur_button = "[center][img=8]Sprites/UI/Controls/Circle_small.png[/img]"
	buttons[2].set_button_text()
	restart_desc.text = "Restart_desc_G_PS"
	btm_desc_label.text = "BtM_desc_PS"

func _input(_event):
	if get_tree().paused and usable:
		check_and_set()
		if Input.is_action_pressed(&"Restart"):
			if timer_restart.is_stopped():
				timer_restart.start(time_for_timers)
		else:
			timer_restart.stop()
			progress_bar_restart.value = 0
		if Input.is_action_just_pressed(&"Settings"):
			usable = false
			if GlobalSapphire.mobile_version:
				for i in get_tree().get_nodes_in_group(&"M_hide_settings"):
					i.hide()
			settings.set_default()
			settings.show()
		if Input.is_action_pressed(&"Back_to_menu"):
			if timer_back_to_menu.is_stopped():
				timer_back_to_menu.start(time_for_timers)
		else:
			timer_back_to_menu.stop()
			progress_bar_back_to_menu.value = 0

func check_and_set() -> void:
	if Input.get_connected_joypads().size() > 0 and cur_controls != "gamepad":
		var joy_name := Input.get_joy_name(0)
		if "PS3" in joy_name or "PS4" in joy_name or "PS5" in joy_name or "PS6" in joy_name:
			set_controls_for_gamepad_playstation()
		else:
			set_controls_for_gamepad_xbox()
	elif cur_controls != "keyboard":
		set_controls_for_keyboard()

func _on_settings_hide_settings():
	if GlobalSapphire.mobile_version:
		for i in get_tree().get_nodes_in_group("M_hide_settings"):
			i.show()
	usable = true

func stop_music():
	settings.music_stream_player.stop()

func _on_timer_restart_timeout():
	progress_bar_restart.value += 4
	if progress_bar_restart.value >= 48:
		usable = false
		get_tree().paused = false
		emit_signal("restart_a_level")

func _on_timer_back_to_menu_timeout():
	progress_bar_back_to_menu.value += 4
	if progress_bar_back_to_menu.value >= 48:
		usable = false
		get_tree().paused = false
		if is_instance_valid(GlobalSapphire.player):
			if is_instance_valid(GlobalSapphire.player.player_body):
				GlobalSapphire.player.player_body.body_resources["Body_weapon_change"].change_color(GlobalSapphire.player.player_body.default_color,GlobalSapphire.player.player_body.body_sprite)
		emit_signal("please_back_to_menu")
