extends Boss_AI

@onready var head = preload("res://Scenes/Enemies/Flying/Flying_head_Unknown.tscn")
@onready var timer_phase_0 = $Timer_phase_0
@onready var timer_phase_1 = $Timer_phase_1
@onready var head_position = $Boss_body/Head_position
@onready var boss_head = $Boss_body/Body/Head

const time_for_shooting : float = 1.1
const time_for_jump : float = 1.3
const distance : float = 680.0

var achievement_sprite := preload("res://Sprites/UI/Achievements/Unknown_head.png")
var cur_target : Robot_body
var spawned_head : bool = false

func check_boss_state() -> void:
	if is_instance_valid(boss_body):
		match phase:
			0:
				boss_movement()
				if timer_phase_0.is_stopped():
					timer_phase_0.start(time_for_shooting)
			1:
				boss_movement()
				if timer_phase_1.is_stopped():
					timer_phase_1.start(time_for_jump)
			2:
				boss_movement()
				timer_phase_1.stop()
				if !spawned_head:
					spawned_head = true
					boss_head.hide()
					spawn_head()

func spawn_head() -> void:
	var spawn_this = head.instantiate()
	spawn_this.global_position = head_position.global_position/4
	spawn_this.boss_body = boss_body
	get_parent().add_child(spawn_this)
	spawn_this.enemy_body.now_dead.connect(give_achievement)
	spawn_this.enemy_body.body_resources["Body_change_direction"].change_direction(boss_body.scale.y,spawn_this.enemy_body)

func give_achievement() -> void:
	if not "Unknown_head" in GlobalSapphire.achievements_data.unlocked_achievements:
		GlobalSapphire.get_this_achievement_and_save("Unknown_head")
		GlobalSapphire.player.player_UI._got_achievement("Unknown_head",achievement_sprite)

func boss_movement() -> void:
	if is_instance_valid(cur_target):
		if cur_target.global_position.x > boss_body.global_position.x:
			if boss_body.scale.y == -1:
				boss_body.change_direction(-boss_body.scale.y)
			if abs(cur_target.global_position.x-boss_body.global_position.x) > distance:
				boss_body.movement(1.0)
			else:
				boss_body.movement(0.0)
		else:
			if boss_body.scale.y == 1:
				boss_body.change_direction(-boss_body.scale.y)
			if abs(cur_target.global_position.x-boss_body.global_position.x) > distance:
				boss_body.movement(-1.0)
			else:
				boss_body.movement(0.0)

func check_if_needed_to_change_state() -> void:
	if is_instance_valid(boss_body):
		match phase:
			0:
				if boss_body.hp <= 12:
					phase = 1
			1:
				if boss_body.hp <= 9:
					phase = 2

func _on_timer_phase_0_timeout():
	if is_instance_valid(boss_body):
		boss_body.shoot()

func _on_boss_body_detected_a_body(detected_body):
	if detected_body is Moving_body:
		if detected_body.type == GlobalEnum.BodyTypes.PLAYER:
			cur_target = detected_body

func _on_timer_phase_1_timeout():
	if is_instance_valid(boss_body):
		boss_body.jump(true)
