extends "res://Character/Enemy/Enemy.gd"

class_name FlyingEnemy

var speed = 200

var seePlayer = false
var player
var attackPlayer = false

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_state:
		STATES.IDLE:
			$AnimatedSprite2D.play("fly")
		STATES.ATTACK:
			$AnimatedSprite2D.play("attack")
	
	if(seePlayer and player):
		if global_position.direction_to(player.global_position).x < 0:
			$AnimatedSprite2D.flip_h = true
			$enemy_hitbox/CollisionShape2D.position = Vector2(-31.5, 10)
		else:
			$AnimatedSprite2D.flip_h = false
			$enemy_hitbox/CollisionShape2D.position = Vector2(31.5, 10)
		velocity = global_position.direction_to(player.global_position) * speed
		move_and_slide()
		if(attackPlayer):
			change_state(STATES.ATTACK)
		else:
			change_state(STATES.IDLE)
	update_health()
	
func enemy():
	pass

func _on_detect_player_body_entered(body):
	if body.has_method("player"):
		seePlayer = true
		player = body

func _on_detect_player_body_exited(body):
	if body.has_method("player"):
		seePlayer = false
		player

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		attackPlayer = true
		player = body
	
func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		attackPlayer = false
		player
