extends "res://Character/Character.gd"

class_name Player

var look_direction = 1

var hasJumped = false

func _physics_process(delta):
	movement(delta)

func movement(delta):
	# Implements gravity
	velocity.y += gravity * delta
	
	var running_speed = 0.17
	
	if HP == 0:
		$AnimatedSprite2D.play("death")
		
	# Implements horizontal movement
	if Input.is_action_pressed("ui_right"):
		look_direction = 1
		velocity.x = min(velocity.x + ACCELERATION, SPEED)
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run")
		if is_on_floor():
			if $"../Timer".time_left <= 0:
				$"../RunningSound".pitch_scale = randf_range(0.8, 1.2)
				$"../RunningSound".play()
				$"../Timer".start(running_speed)
		
	elif Input.is_action_pressed("ui_left"):
		look_direction = -1
		velocity.x = max(velocity.x - ACCELERATION, -SPEED)
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")
		if is_on_floor():
			if $"../Timer".time_left <= 0:
				$"../RunningSound".pitch_scale = randf_range(0.8, 1.2)
				$"../RunningSound".play()
				$"../Timer".start(running_speed)
	else:
		FRICTION = true
		$AnimatedSprite2D.play("idle")
		
	if is_on_floor():
		if hasJumped == true:
			$"../FallSound".play()	
			hasJumped = false
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_VELOCITY
			$"../JumpSound".play()
			hasJumped = true
		if FRICTION == true:
			velocity.x = lerp(velocity.x, 0.0, 0.2)
	else:
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("fall")
	
		if FRICTION == true:
			velocity.x = lerp(velocity.x, 0.0, 0.25)
			
	move_and_slide()
