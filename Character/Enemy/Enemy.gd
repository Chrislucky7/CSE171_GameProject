extends "res://Character/Character.gd"

class_name Enemy

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	update_health()
	
func update_health():
	var healthbar = $healthbar
	healthbar.value = HP
	if HP == 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
	
