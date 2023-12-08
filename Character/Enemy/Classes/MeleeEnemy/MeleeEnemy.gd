extends "res://Character/Enemy/Enemy.gd"

class_name meleeEnemy

var speed = 150
var seePlayer = false
var player
var attackPlayer = false

func _physics_process(delta):
	match current_state:
		STATES.IDLE:
			$AnimatedSprite2D.play("idle")
		STATES.RUN:
			$AnimatedSprite2D.play("run")
		STATES.ATTACK:
			$AnimatedSprite2D.play("attack")
	
	if(seePlayer and player):
		change_state(STATES.RUN)
		if global_position.direction_to(player.global_position).x < 0:
			$AnimatedSprite2D.flip_h = true
			$enemy_hitbox/CollisionShape2D.position = Vector2(-91.25, -27.25)
		else:
			$AnimatedSprite2D.flip_h = false
			$enemy_hitbox/CollisionShape2D.position = Vector2(91.25, -27.25)
		velocity.x = global_position.direction_to(player.global_position).x * speed
		move_and_slide()
	if(attackPlayer and player):
		change_state(STATES.ATTACK)
	
	velocity.y += gravity * delta
	update_health()
	
		
func enemy():
	pass
	
func _on_detect_player_body_entered(body):
	seePlayer = true
	player = body
	


func _on_detect_player_body_exited(body):
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
