class_name Boss_head
extends Control

@export var head_texture : Texture2D
@onready var sprite_2d = $Boss_head/Sprite2D

func _ready():
	change_head_texture(head_texture)

func change_head_texture(new_texture:Texture2D=head_texture) -> void:
	sprite_2d.texture = new_texture

func make_head_black_and_white() -> void:
	sprite_2d.material["shader_parameter/activated"] = true
