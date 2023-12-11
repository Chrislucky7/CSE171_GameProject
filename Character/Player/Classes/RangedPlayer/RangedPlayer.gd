extends "res://Character/Player/Player.gd"

class_name RangedPlayer

var player_is_alive = true

var enemy_inattack_range = false
var enemy_attack_cooldown = true

@onready var reload_progress = %ReloadProgress
@onready var reload_timer = %reloadTimer
@onready var fastreloadtimer = %fastreloadtimer

@onready var percentage_of_time_reload

@onready var skill_progress = %SkillProgress
@onready var skill_timer = %skillTimer
@onready var percentage_of_time_skill


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
	reload_progress.value = 100
	skill_progress.value = 100

func _physics_process(delta):
	movement(delta)
	enemy_attack()
	update_health()
	update_reloadprogress()
	update_skillprogress()
	
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
		%skillTimer.start()
		attack_speed = skill_aspd
		duration_count += delta
		
		if duration_count >= skill_duration:
			attack_speed = aspd_hold
			skill_count = 0
			duration_count = 0
			skill_active = false
	
	if HP <= 0:
		get_tree().change_scene_to_file("res://World/game_over.tscn")

# Makes instance of projectile in the world scene
func shoot():
	var projectile_instance = Projectile.instantiate()
	owner.add_child(projectile_instance)
	projectile_instance.global_transform = $Marker2D.get_global_transform()
	projectile_instance.get_node("Area2D").set_look_direction(look_direction)
	
	if skill_active:
		%fastreloadtimer.start()
	else:
		%reloadTimer.start()
		

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
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(HP)

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	
func update_health():
	var healthbar = %healthBar
	healthbar.value = HP
	
func update_reloadprogress():
	if skill_active:
		if fastreloadtimer.get_time_left() > 0:
			percentage_of_time_reload = (
			(1-fastreloadtimer.get_time_left()/ fastreloadtimer.get_wait_time()) * 100)
		
		reload_progress.value = percentage_of_time_reload
	else:
		if reload_timer.get_time_left() > 0:
			percentage_of_time_reload = (
				(1-reload_timer.get_time_left()/ reload_timer.get_wait_time()) * 100)
			
			reload_progress.value = percentage_of_time_reload

func _on_reload_timer_timeout():
	reload_progress.value = 100.0
	
func update_skillprogress():
	if skill_timer.get_time_left() > 0:
		percentage_of_time_skill = (
			(1-skill_timer.get_time_left()/ skill_timer.get_wait_time()) * 100)
		
		skill_progress.value = percentage_of_time_skill

func _on_skill_timer_timeout():
	skill_progress.value = 100.0
	



func _on_fastreloadtimer_timeout():
	reload_progress.value = 100.0
