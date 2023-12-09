extends CharacterBody2D

class_name Character

var SPEED = 400.0
const JUMP_VELOCITY = -615.0
const ACCELERATION = 75.0
var FRICTION = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var HP = 100
var knockback = 1000


enum STATES {IDLE, RUN, ATTACK, STAGGER, DEAD}
@export var current_state = STATES.IDLE
var previous_state = null

# State machine
func change_state(new_state):
	previous_state = current_state
	current_state = new_state
	
	match current_state:
		STATES.DEAD:
			#AnimatedSprite2D.play("death")
			queue_free()

func take_damage(damage):
	HP -= damage
	$AnimatedSprite2D/AnimationPlayer.play("flash_damage")
	if HP <= 0:
		change_state(STATES.DEAD)
	else:
		change_state(STATES.STAGGER)
