extends CanvasLayer

@export var elements_2D : Node2D
@export var player_plane : Hack_planes_Player
@export var enemies : Array[PackedScene]
@export_multiline var top_text : String
@export var top_text_label : Label

@export_group("Colors")
@export var color_hp_3 : Color = Color.GREEN
@export var color_hp_2 : Color = Color.YELLOW
@export var color_hp_1 : Color = Color.RED

@onready var timer = $Timer
@onready var enemy_positions_node : Node2D = $Elements_2D/Enemy_positions
@onready var enemies_label = $Elements_2D/Enemies
# Databases
var projectiles_database : Hack_planes_projectiles_database = preload("res://Resources/Databases/Hack_planes_Projectiles_database.tres")

var enemy_positions : Array[int] = []
var amount_of_enemies : int = 0
var all_enemies_spawned : bool = false
var minigame_ended : bool = false
var cur_left_limit_for_text : int = 0
var substr_this_amount : int = 0
var enemies_dict : Dictionary
var enemies_blocks : Array[String]

signal now_minigame_ended()
signal minigame_failed()

func _ready():
	substr_this_amount = top_text_label.text.length()
	timer.start(0.09)
	projectiles_database.add_projectiles()
	top_text_label.self_modulate = color_hp_3
	if check_enemies():
		spawn_enemies()

func _physics_process(_delta):
	if all_enemies_spawned and amount_of_enemies == 0 and !minigame_ended:
		minigame_ended = true
		end_minigame()
	if !is_instance_valid(player_plane) and !minigame_ended:
		minigame_ended = true
		emit_signal("minigame_failed")

func change_top_text() -> void:
	top_text_label.text = top_text.substr(cur_left_limit_for_text,cur_left_limit_for_text+substr_this_amount)
	cur_left_limit_for_text += substr_this_amount
	if cur_left_limit_for_text+substr_this_amount >= top_text.length():
		cur_left_limit_for_text = 0

func end_minigame() -> void:
	emit_signal("now_minigame_ended")

func spawn_projectile(projectile_id:int,atk:int,pos:Vector2) -> void:
	if projectile_id in projectiles_database.projectiles.keys():
		var new_p = projectiles_database.projectiles[projectile_id].instantiate()
		new_p.atk = atk
		new_p.global_position = pos/4
		elements_2D.add_child(new_p)
	else:
		push_error("No projectile")

func check_enemies() -> bool:
	var check_this_enemy
	if enemies.size() == 0 or enemies.size() > enemy_positions_node.get_child_count():
		push_warning("There is no enemies or too many enemies")
		return false
	for i in enemies:
		if i != null:
			check_this_enemy = i.instantiate()
			if not check_this_enemy is Hack_planes_Plane:
				push_error("This is not a plane")
				return false
	return true

func spawn_enemies() -> void:
	var positions : Array[Node] = enemy_positions_node.get_children()
	var new_enemy
	var cur_index : int = 0
	for i in positions:
		if enemy_positions[cur_index] != 0:
			new_enemy = enemies[enemy_positions[cur_index]].instantiate()
			new_enemy.screen = self
			new_enemy.now_dead.connect(_dead_enemy)
			if cur_index < 9:
				enemies_label.text += "$EN0"+str(cur_index)+"\n\n"
				enemies_blocks.append("$EN0"+str(cur_index))
			else:
				push_warning("Impossible")
			i.add_child(new_enemy)
			enemies_dict[cur_index] = new_enemy
			amount_of_enemies += 1
		cur_index += 1
		if cur_index >= enemy_positions.size():
			all_enemies_spawned = true
			break
	enemies_blocks.append("$PL01")
	enemies_label.text += enemies_blocks.back()+"\n\n"
	all_enemies_spawned = true

func _dead_enemy() -> void:
	var enemy_index : int = 0
	var new_text : String = ""
	amount_of_enemies -= 1
	enemy_index = check_dead_enemies()
	if enemy_index != -1:
		enemies_blocks[enemies_blocks.find("$EN0"+str(enemy_index))] = ""
		for i in enemies_blocks:
			new_text += i+"\n\n"
		enemies_label.text = new_text

func check_dead_enemies() -> int:
	for i in enemies_dict.keys():
		if !is_instance_valid(enemies_dict[i]):
			enemies_dict.erase(i)
			return i
		elif enemies_dict[i].hp <= 0:
			enemies_dict.erase(i)
			return i
	return -1

func _on_player_got_hit(new_hp):
	match new_hp:
		2:
			top_text_label.self_modulate = color_hp_2
		1:
			top_text_label.self_modulate = color_hp_1


func _on_timer_timeout():
	change_top_text()
