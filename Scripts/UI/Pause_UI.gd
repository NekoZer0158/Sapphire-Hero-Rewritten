class_name Pause_UI
extends Control

@export_color_no_alpha var label_shadow_color : Color = Color("4562d6")
@export_color_no_alpha var progress_bar_bg_color : Color = Color("3baaff")
@export var buttons : Array[Button_UI]
@export var time_for_timers : float = 0.08

@onready var progress_bar_restart := $Restart_button/ProgressBar
@onready var progress_bar_back_to_menu := $Back_to_menu/ProgressBar
@onready var settings := $Settings
@onready var controls: Controls = $Controls
@onready var timer_restart := $Timer_restart
@onready var timer_back_to_menu := $Timer_back_to_menu
@onready var restart_desc_label : RichTextLabel= $Restart_desc
@onready var controls_desc_label: RichTextLabel = $Controls_desc
@onready var settings_desc_label: RichTextLabel = $Settings_desc
@onready var btm_desc_label: RichTextLabel = $BtM_desc
@onready var mobile_node: Control = $Mobile

var usable : bool = true

var cur_controls : String = "keyboard"

signal restart_a_level()
signal please_back_to_menu()

enum Buttons{RESTART,SETTINGS,BACK_TO_MENU,CONTROLS}

func _ready():
	for i in buttons:
		i.change_label_shadow_color(label_shadow_color)
	if OS.has_feature("mobile"):
		for i in buttons:
			i.hide()
		controls_desc_label.queue_free()
		settings_desc_label.queue_free()
		$Restart_desc.text = TranslationServer.translate("Restart_desc_m")
		progress_bar_back_to_menu = $Mobile/ProgressBar_btm
		progress_bar_restart = $Mobile/ProgressBar_restart
		btm_desc_label.text = TranslationServer.translate("BtM_desc_m")
		btm_desc_label.position.y = 616
		mobile_node.show()
	else:
		mobile_node.queue_free()
		set_controls_for_keyboard()
	progress_bar_back_to_menu.theme["ProgressBar/styles/fill"].bg_color = progress_bar_bg_color
	check_and_set()

func set_controls_for_keyboard() -> void:
	buttons[Buttons.RESTART].cur_button = "[center]R"
	buttons[Buttons.RESTART].set_button_text()
	buttons[Buttons.SETTINGS].cur_button = "[center]S"
	buttons[Buttons.SETTINGS].set_button_text()
	buttons[Buttons.BACK_TO_MENU].cur_button = "[center]B"
	buttons[Buttons.BACK_TO_MENU].set_button_text()
	buttons[Buttons.CONTROLS].cur_button = "[center]C"
	buttons[Buttons.CONTROLS].set_button_text()
	restart_desc_label.text = "Restart_desc"
	controls_desc_label.text = "Controls_desc"
	settings_desc_label.text = "Settings_desc"
	btm_desc_label.text = "BtM_desc"

func set_controls_for_gamepad_xbox() -> void:
	buttons[Buttons.RESTART].cur_button = "[center]Y"
	buttons[Buttons.RESTART].set_button_text()
	buttons[Buttons.SETTINGS].cur_button = "[center]A"
	buttons[Buttons.SETTINGS].set_button_text()
	buttons[Buttons.BACK_TO_MENU].cur_button = "[center]B"
	buttons[Buttons.BACK_TO_MENU].set_button_text()
	buttons[Buttons.CONTROLS].cur_button = "[center]X"
	buttons[Buttons.CONTROLS].set_button_text()
	restart_desc_label.text = "Restart_desc_G"
	controls_desc_label.text = "Controls_desc_xbox_M30"
	settings_desc_label.text = "Settings_desc_xbox_M30"
	btm_desc_label.text = "BtM_desc"

func set_controls_for_gamepad_m30() -> void:
	buttons[Buttons.RESTART].cur_button = "[center]C"
	buttons[Buttons.RESTART].set_button_text()
	buttons[Buttons.SETTINGS].cur_button = "[center]A"
	buttons[Buttons.SETTINGS].set_button_text()
	buttons[Buttons.BACK_TO_MENU].cur_button = "[center]B"
	buttons[Buttons.BACK_TO_MENU].set_button_text()
	buttons[Buttons.CONTROLS].cur_button = "[center]X"
	buttons[Buttons.CONTROLS].set_button_text()
	restart_desc_label.text = "Restart_desc_G_M30"
	controls_desc_label.text = "Controls_desc_xbox_M30"
	settings_desc_label.text = "Settings_desc_xbox_M30"
	btm_desc_label.text = "BtM_desc"

func set_controls_for_gamepad_playstation() -> void:
	buttons[Buttons.RESTART].cur_button = "[center][img=8]Sprites/UI/Controls/Triangle_small.png[/img]"
	buttons[Buttons.RESTART].set_button_text()
	buttons[Buttons.SETTINGS].cur_button = "[center][img=8]Sprites/UI/Controls/X_small.png[/img]"
	buttons[Buttons.SETTINGS].set_button_text()
	buttons[Buttons.BACK_TO_MENU].cur_button = "[center][img=8]Sprites/UI/Controls/Circle_small.png[/img]"
	buttons[Buttons.BACK_TO_MENU].set_button_text()
	buttons[Buttons.CONTROLS].cur_button = "[center][img=8]Sprites/UI/Controls/Square_small.png[/img]"
	buttons[Buttons.CONTROLS].set_button_text()
	restart_desc_label.text = "Restart_desc_G_PS"
	controls_desc_label.text = "Controls_desc_PS"
	settings_desc_label.text = "Settings_desc_PS"
	btm_desc_label.text = "BtM_desc_PS"

func _input(_event):
	if get_tree().paused and usable:
		check_and_set()
		if Pressed_key_check._check_if_this_button_pressed(&"Restart",&"Restart_M30"):
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
		elif Input.is_action_pressed(&"Controls"):
			usable = false
			if GlobalSapphire.mobile_version:
				for i in get_tree().get_nodes_in_group(&"M_hide_settings"):
					i.hide()
			controls.set_default()
			controls.show()
		if Input.is_action_pressed(&"Back_to_menu"):
			if timer_back_to_menu.is_stopped():
				timer_back_to_menu.start(time_for_timers)
		else:
			timer_back_to_menu.stop()
			progress_bar_back_to_menu.value = 0

func check_and_set() -> void:
	if Input.get_connected_joypads().size() > 0 and cur_controls != "gamepad":
		var joy_name := Input.get_joy_name(0)
		if "PS3" in joy_name or "PS4" in joy_name or "PS5" in joy_name or "PS6" in joy_name or "PS2" in joy_name or "PS1" in joy_name:
			set_controls_for_gamepad_playstation()
		else:
			match GlobalSapphire.xbox_gamepad_type:
				GlobalEnum.XboxGamepadTypes.XBOX:
					set_controls_for_gamepad_xbox()
				GlobalEnum.XboxGamepadTypes.M30:
					set_controls_for_gamepad_m30()
	elif cur_controls != "keyboard":
		set_controls_for_keyboard()

func _on_hide_this():
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
		restart_a_level.emit()

func _on_timer_back_to_menu_timeout():
	progress_bar_back_to_menu.value += 4
	if progress_bar_back_to_menu.value >= 48:
		usable = false
		get_tree().paused = false
		if is_instance_valid(GlobalSapphire.player):
			if is_instance_valid(GlobalSapphire.player.player_body):
				GlobalSapphire.player.player_body.body_resources["Body_weapon_change"].change_color(GlobalSapphire.player.player_body.default_color,GlobalSapphire.player.player_body.body_sprite)
		please_back_to_menu.emit()
