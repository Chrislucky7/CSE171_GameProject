extends "res://Character/Enemy/Enemy.gd"

class_name ExplodingEnemy

var player
var player_inner

var detect_inner = false
var entered = false
var explode = 3.0			# Time before explosion in seconds
var explode_count = 0.0		# Explosion counter
var damage = 50.0
 
func _ready():
	SPEED = 100.0

func _physics_process(delta):
	# States control the animations
	match current_state:
		STATES.IDLE: 
			$AnimatedSprite2D.play("idle")
		STATES.RUN:
			$AnimatedSprite2D.play("run")
	
	# Implements gravity
	velocity.y += gravity * delta
	
	# Enemy moves towards player when detected
	if player && detect_inner == false && entered == false:
		change_state(STATES.RUN)
		if global_position.direction_to(player.global_position).x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		velocity = global_position.direction_to(player.global_position) * SPEED
	
	# When enemy gets close enough, start a timer to count down until explosion
	if detect_inner == true || entered == true:
		change_state(STATES.IDLE)
		explode_count += delta
		if explode_count >= explode:
			if player_inner:
				player_inner.take_damage(damage)
				player_inner.velocity = Vector2(knockback,knockback) * global_position.direction_to(player.global_position).normalized()
			queue_free()
	
	if entered == false: move_and_slide()

func _on_detect_player_body_entered(body):
	if body.is_in_group("Player"):
		player = body

func _on_detect_player_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		velocity = Vector2(0,0)
		change_state(STATES.IDLE)

func _on_detect_inner_body_entered(body):
	if body.is_in_group("Player"):
		detect_inner = true
		entered = true
		player_inner = body

func _on_detect_inner_body_exited(body):
	if body.is_in_group("Player"):
		detect_inner = false
		player_inner = null
