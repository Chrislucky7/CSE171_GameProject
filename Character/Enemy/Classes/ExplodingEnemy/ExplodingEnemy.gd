extends "res://Character/Enemy/Enemy.gd"

class_name ExplodingEnemy

# Checks if body belongs to player
var player
var player_inner

# Checks if player enters DetectPlayer
var detected = false

var detect_inner = false	# Checks if player enters DetectInner
var entered = false			# Checks if player has entered DetectInner at least once
var explode = 3.0			# Time before explosion in seconds
var explode_count = 0.0		# Explosion counter
var damage = 50.0			# Damage dealt by explosion
 
func _ready():
	SPEED = 100.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	
	# When enemy is detected and gets close enough, start explosion countdown
	if detected == true && (detect_inner == true || entered == true):
		change_state(STATES.IDLE)
		explode_count += delta
		
		# If player is close to the enemy, take damage and apply knockback
		if explode_count >= explode:
			if player_inner:
				player_inner.take_damage(damage)
				player_inner.velocity = Vector2(knockback,knockback) * global_position.direction_to(player.global_position).normalized()
			queue_free()
	
	# Stop enemy from moving after player gets close enough
	if entered == false: move_and_slide()

func _on_detect_player_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		detected = true
		

func _on_detect_player_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		velocity = Vector2(0,0)
		change_state(STATES.IDLE)

func _on_detect_inner_body_entered(body):
	if body.is_in_group("Player") && detected:
		detect_inner = true
		entered = true
		player_inner = body

func _on_detect_inner_body_exited(body):
	if body.is_in_group("Player"):
		detect_inner = false
		player_inner = null
