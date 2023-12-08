extends "res://Character/Enemy/Enemy.gd"

var speed = 150
var seePlayer = false
var player = null

func _physics_process(delta):
	match current_state:
		STATES.IDLE:
			$AnimatedSprite2D.play("idle")
	
	if(seePlayer):
		velocity.x = global_position.direction_to(player.global_position).x * speed
		move_and_slide()
		
	update_health()
		
func enemy():
	pass
	
func _on_detect_player_body_entered(body):
	player = body
	seePlayer = true


func _on_detect_player_body_exited(body):
	player = null
	seePlayer = false
