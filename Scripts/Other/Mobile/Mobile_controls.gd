class_name Mobile_controls
extends Control

@export_range(0.0,1.0) var buttons_visibility : float = 0.5
@export var activated_texture_move : Texture2D
@export var activated_texture_shoot : Texture2D
@export var activated_texture_jump : Texture2D
@export var activated_texture_activate : Texture2D
@export var activated_texture_weapon : Texture2D
@export var activated_texture_pause : Texture2D
@export var activated_texture_hp_refill : Texture2D

@onready var touch_screen_button_left: TouchScreenButton = $Left_and_right/TouchScreenButton_left
@onready var touch_screen_button_jump: TouchScreenButton = $Right_controls/TouchScreenButton_Jump
@onready var touch_screen_button_right: TouchScreenButton = $Left_and_right/TouchScreenButton_right
@onready var touch_screen_button_shoot: TouchScreenButton = $Right_controls/TouchScreenButton_Shoot
@onready var touch_screen_button_next_weapon: TouchScreenButton = $Right_controls/TouchScreenButton_next_weapon
@onready var touch_screen_button_previous_weapon: TouchScreenButton = $Right_controls/TouchScreenButton_previous_weapon
@onready var touch_screen_button_activate: TouchScreenButton = $Right_controls/TouchScreenButton_activate
@onready var tsb_pause: TouchScreenButton = $Control_pause/TSB_pause
@onready var tsb_hp_refill: TouchScreenButton = $Control_pause/TSB_hp_refill

var player_body : Moving_body
var player_UI : Player_UI

func _ready() -> void:
	$Plane_minigame/TSB_down.modulate.a = buttons_visibility
	$Plane_minigame/TSB_up.modulate.a = buttons_visibility
	$Right_controls/TouchScreenButton_activate.modulate.a = buttons_visibility
	for i in get_tree().get_nodes_in_group(&"Player_controls_mobile"):
		i.modulate.a = buttons_visibility
	$Left_and_right.modulate.a = 1.0

func change_activated_textures() -> void:
	touch_screen_button_left.texture_pressed = activated_texture_move
	touch_screen_button_right.texture_pressed = activated_texture_move
	$Plane_minigame/TSB_down.texture_pressed = activated_texture_move
	$Plane_minigame/TSB_up.texture_pressed = activated_texture_move
	touch_screen_button_shoot.texture_pressed = activated_texture_shoot
	touch_screen_button_next_weapon.texture_pressed = activated_texture_weapon
	touch_screen_button_previous_weapon.texture_pressed = activated_texture_weapon
	touch_screen_button_jump.texture_pressed = activated_texture_jump
	touch_screen_button_activate.texture_pressed = activated_texture_activate
	tsb_hp_refill.texture_pressed = activated_texture_hp_refill
	tsb_pause.texture_pressed = activated_texture_pause

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		player_UI.pause_was_pressed()

func _on_tsb_pause_pressed() -> void:
	if get_tree().paused:
		touch_screen_button_left.hide()
		touch_screen_button_right.hide()
		touch_screen_button_shoot.hide()
		touch_screen_button_jump.hide()
		tsb_hp_refill.hide()
		touch_screen_button_next_weapon.hide()
		touch_screen_button_previous_weapon.hide()
	else:
		touch_screen_button_left.show()
		touch_screen_button_right.show()
		touch_screen_button_shoot.show()
		touch_screen_button_jump.show()
		tsb_hp_refill.show()
		touch_screen_button_next_weapon.show()
		touch_screen_button_previous_weapon.show()
