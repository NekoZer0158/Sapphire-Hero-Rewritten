class_name Cutscene
extends Control

@export var all_pictures : Array[PackedScene]
@export var pictures_marker : Marker2D
@export var parent_node : Node
@export var transition_time : float = 0.7
@export var text_first_word : String

@onready var label = $Label
@onready var transition = $Transition

var pictures : Array[Node]
var amount_of_pictures : int = 0
var cur_text : int = 1
var can_control : bool = true

func _ready():
	var new_pic
	mouse_filter = MOUSE_FILTER_IGNORE
	transition.mouse_filter = MOUSE_FILTER_IGNORE
	for i in all_pictures:
		new_pic = i.instantiate()
		pictures.append(new_pic)
		pictures_marker.add_child(new_pic)
		new_pic.hide()
	pictures.front().show()
	if text_first_word == "":
		push_warning("No text")
	label.text = text_first_word+"_"+str(cur_text)
	amount_of_pictures = pictures.size()
	if OS.has_feature("mobile"):
		var add_this_button := Button.new()
		add_this_button.position = Vector2(-250,0)
		add_this_button.size = Vector2(3000,2500)
		add_this_button.flat = true
		add_this_button.focus_mode = Control.FOCUS_NONE
		add_this_button.pressed.connect(next)
		add_child(add_this_button)
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(transition,"modulate",Color(0.0,0.0,0.0,0.0),transition_time)
	await new_tween.finished

func next() -> void:
	if cur_text+1 <= amount_of_pictures:
		next_text()
	else:
		end_intro()

func _input(event):
	if can_control:
		if event.is_action_pressed(&"Menu_Activate"):
			next()
		elif event.is_action_pressed("Pause"):
			end_intro()

func next_text() -> void:
	cur_text += 1
	pictures.front().queue_free()
	pictures.erase(pictures.front())
	pictures.front().show()
	label.text = text_first_word+"_"+str(cur_text)

func end_intro() -> void:
	can_control = false
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(transition,"modulate",Color(0.0,0.0,0.0,1.0),transition_time)
	await new_tween.finished
	parent_node.use_transition()
	queue_free()
