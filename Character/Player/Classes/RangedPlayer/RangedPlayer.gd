extends "res://Character/Player/Player.gd"

class_name RangedPlayer

signal HP_changed

var player_is_alive = true

var enemy_inattack_range = false
var enemy_attack_cooldown = true

# Normal attack
var attack_speed = 2.0			# Attack speed in seconds
var attack_lock = 2.0		
var attack_count = 0
var special_attack = 10

# Skill
var skill_active = false
var skill_cd = 20.0
var skill_aspd = 0.5
var skill_count = 20.0
var skill_duration = 5.0
var duration_count = 0.0
var aspd_hold = 0.0
 
var Projectile = preload("res://Character/Player/Classes/RangedPlayer/Projectile.tscn")
var SpecialProjectile = preload("res://Character/Player/Classes/RangedPlayer/special_projectile.tscn")

func _ready():
	aspd_hold = attack_speed

func _physics_process(delta):
	movement(delta)
	enemy_attack()
	
	
	
	# Shoot projectile
	attack_lock += delta
	if Input.is_action_just_pressed("shoot") && attack_lock >= attack_speed:
		if attack_count == special_attack:
			special()
			attack_count = 0
		else:
			shoot()
		attack_count += 1
		attack_lock = 0
	
	# Skill
	skill_count += delta
	if (Input.is_action_just_pressed("skill") && skill_count >= skill_cd) || skill_active:
		skill_active = true
		attack_speed = skill_aspd
		duration_count += delta
		if duration_count >= skill_duration:
			attack_speed = aspd_hold
			skill_count = 0
			duration_count = 0
			skill_active = false

# Makes instance of projectile in the world scene
func shoot():
	var projectile_instance = Projectile.instantiate()
	owner.add_child(projectile_instance)
	projectile_instance.global_transform = $Marker2D.get_global_transform()
	projectile_instance.get_node("Area2D").set_look_direction(look_direction)

# Makes instance of special projectile in the world scene
func special():
	var special_instance = SpecialProjectile.instantiate()
	owner.add_child(special_instance)
	special_instance.global_transform = $Marker2D.get_global_transform()
	special_instance.get_node("Area2D").set_look_direction(look_direction)
	velocity.x = -knockback * look_direction
	
func player():
	pass


func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		if HP > 0:
			self.take_damage(10)
			HP_changed.emit()
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(HP)

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	
func update_health():
	var healthbar = $CharacterBody2D/healthbar
	healthbar.value = HP
	if HP == 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
	
