class_name Bomb
extends Projectile

@export var explosion_sprite : AnimatedSprite2D
@export var timer_explosion : Timer
@export_group("Explosion areas")
@export var explosion_small : Area2D
@export var explosion_medium : Area2D
@export var explosion_large : Area2D

enum Explosions {SMALL,MEDIUM,LARGE}

var boom : bool = false
var cur_explosion : Explosions
var cur_explosion_state : int = 0

var bodies_in_small_area : Array[Moving_body] = []
var bodies_in_medium_area : Array[Moving_body] = []
var bodies_in_large_area : Array[Moving_body] = []

const explosion_time : float = 0.12

func _physics_process(delta):
	if !boom:
		position += speed * delta

func explosion():
	boom = true
	_on_timer_explosion_timeout()
	timer_explosion.start(explosion_time)

func check_explosion(explosion_state:Explosions):
	match explosion_state:
		Explosions.SMALL:
			for i in bodies_in_small_area:
				i.hit(atk*3)
		Explosions.MEDIUM:
			for i in bodies_in_medium_area:
				match cur_explosion_state:
					0:
						i.hit(atk*2)
					1:
						i.hit(atk)
		Explosions.LARGE:
			for i in bodies_in_large_area:
				i.hit(atk)

func _on_area_2d_body_entered(body):
	if !boom:
		if body is Moving_body:
			if body.type != type and not body.type in GlobalSapphire.type_friendlists[type]:
				explosion()
		elif body is TileMapLayer or body is Moving_platform:
			explosion()

func _on_explosion_small_body_entered(body):
	if body is Moving_body and body != self:
		bodies_in_small_area.append(body)

func _on_explosion_medium_body_entered(body):
	if body is Moving_body and body != self:
		bodies_in_medium_area.append(body)

func _on_explosion_large_body_entered(body):
	if body is Moving_body and body != self:
		bodies_in_large_area.append(body)

func _on_timer_explosion_timeout():
	match cur_explosion_state:
		0:
			if explosion_sprite.frame == 3:
				explosion_sprite.frame -= 1
				cur_explosion_state = 1
			else:
				explosion_sprite.frame += 1
			check_explosion(explosion_sprite.frame-1)
		1:
			queue_free()


func _on_explosion_small_body_exited(body):
	if body is Moving_body and body != self:
		if body in bodies_in_small_area:
			bodies_in_small_area.erase(body)

func _on_explosion_medium_body_exited(body):
	if body is Moving_body and body != self:
		if body in bodies_in_medium_area:
			bodies_in_medium_area.erase(body)

func _on_explosion_large_body_exited(body):
	if body is Moving_body and body != self:
		if body in bodies_in_large_area:
			bodies_in_large_area.erase(body)
