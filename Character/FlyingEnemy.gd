extends "res://Character/Enemy/Enemy.gd"

class_name FlyingEnemy

var player = null
var seePlayer = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(seePlayer):
		velocity = global_position.direction_to(player.global_position) * SPEED
#		move_and_slide()

func _on_detect_player_body_entered(body):
	print(body.get_parent().get_name())
	if(body.get_parent().get_name() == "Player"or
	body.get_parent().get_name() == "RangedPlayer"):
		seePlayer = true
		player = body


func _on_detect_player_body_exited(body):
	if(body.get_parent().get_name() == "Player" or
	body.get_parent().get_name() == "RangedPlayer"):
		seePlayer = false
		player = null
	pass
