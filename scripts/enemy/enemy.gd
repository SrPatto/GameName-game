class_name Enemy
extends Node2D

signal nopal_defeated

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = %Hitbox
@onready var projectiles: Node2D = $Projectiles
@onready var tuna_spawn_point: Marker2D = %tuna_spawnPoint
@onready var thorn_spawn_point: Marker2D = %thorn_spawnPoint
@onready var saliva_spawn_point: Marker2D = %saliva_spawnPoint
@onready var next_move_cd: Timer = %NextMoveCD
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

@export_category("Combat")
@export var max_health: int = 100
@export var list_of_attacks = {
	"basic_attack": false, 
	"strong_attack": false, 
	"tuna_throw": false, 
	"thorns_throw": false, 
	"saliva_spit": false,
	"basic_block": false,
	"thornmail": false }
@export var amount_of_attacks := 3

var available_attacks: Array[String]
var next_attacks: Array[String]
var current_attack: String

var current_health := 0
var is_dead := false

var next_attack_enabled := false
var is_blocking := false
var has_thornmail := false
var is_attacking := false

var threw_tuna := false
var hitted := false

func _ready() -> void:
	animation_player.play("idle")
	current_health = max_health
	hurtbox.parent = self
	hitbox.parent = self
	available_attacks = get_available_moves()
	print("list of available attacks: ", available_attacks)
	next_attacks = get_next_attacks(amount_of_attacks)
	print("list of next attacks: ", next_attacks)
	
	await get_tree().create_timer(2).timeout
	next_attack_enabled = true

func _process(delta: float) -> void:
	if next_attack_enabled && next_move_cd.is_stopped() && !is_dead:
		make_next_attack()
	
	if current_attack == "tuna_throw":
		var current_anim_pos = animation_player.get_current_animation_position()
		if (current_anim_pos >= .8 && current_anim_pos <= 0.9) && !threw_tuna:
			threw_tuna = true
			shoot_tuna()
	elif current_attack == "basic_attack" or current_attack == "strong_attack":
		var current_anim_pos = animation_player.get_current_animation_position()
		if (current_anim_pos >= 1.1 && current_anim_pos <= 1.2) && !hitted:
			hitted = true
			%attack_animation.play("slash")

func change_attack(new_attack: String):
	const ATK_INDICATOR_SCENE = preload("uid://xh8cqq5m0d71")
	var new_atx_ind: Node2D = ATK_INDICATOR_SCENE.instantiate()
	
	current_attack = new_attack
	match  current_attack:
		"basic_attack":
			basic_attack()
		"strong_attack":
			strong_attack()
		"tuna_throw":
			tuna_throw()
		"thorns_throw":
			thorns_throw()
		"saliva_spit":
			saliva_spit()
		"basic_block":
			basic_block()
		"thornmail":
			thornmail()

func make_next_attack():
	var current_attack
	
	if !next_attacks.is_empty():
		current_attack = next_attacks.pop_front()
		change_attack(current_attack)
	else:
		next_attacks = get_next_attacks(amount_of_attacks)
		next_move_cd.set_wait_time(5)
		next_move_cd.start()
		is_attacking = false
		is_blocking = false
		has_thornmail = false

func get_available_moves() -> Array[String]:
	var avail_attacks: Array[String]
	
	for attack in list_of_attacks:
		if list_of_attacks[attack]:
			avail_attacks.append(attack)
	return avail_attacks

func get_next_attacks(lenght: int) -> Array[String]:
	var next_atcks: Array[String]
	
	while (next_atcks.size() < lenght):
		next_atcks.append(available_attacks.pick_random()) 
	
	return next_atcks

func basic_attack():
	next_attack_enabled = false
	is_attacking = true
	next_move_cd.set_wait_time(.5)
	hitbox.collision_shape.disabled = false
	hitbox.damage = 1
	animation_player.play("basic_attack")
	await animation_player.animation_finished
	animation_player.play("idle")
	hitted = false
	%attack_animation.play("RESET")
	next_move_cd.start()

func strong_attack():
	next_attack_enabled = false
	is_attacking = true
	next_move_cd.set_wait_time(1.2)
	hitbox.collision_shape.disabled = false
	hitbox.damage = 2
	animation_player.play("strong_attack")
	await animation_player.animation_finished
	animation_player.play("idle")
	hitted = false
	%attack_animation.play("RESET")
	next_move_cd.start()

func tuna_throw():
	next_attack_enabled = false
	is_attacking = true
	next_move_cd.set_wait_time(.5)
	animation_player.play("throw_tuna")
	
	await animation_player.animation_finished
	
	animation_player.play("idle")
	threw_tuna = false
	next_move_cd.start()

func shoot_tuna():
	const TUNA_SCENE = preload("uid://cbfeo6ssxk6c2")
	var new_tuna: TunaProjectile = TUNA_SCENE.instantiate()
	new_tuna.parent = self
	projectiles.add_child(new_tuna)
	new_tuna.LaunchProjectile(tuna_spawn_point.global_position, Vector2(-.5, 1), 200, 45)

func thorns_throw():
	next_attack_enabled = false
	is_attacking = true
	next_move_cd.set_wait_time(.5)
	
	const THORN_SCENE = preload("uid://du7nugtqp3snk")
	
	var max_thorns := 3
	var thorns_throwed := 0
	
	while thorns_throwed < max_thorns:
		animation_player.play("throw_thorn")
		var new_thorn: ThornProjectile = THORN_SCENE.instantiate()
		new_thorn.parent = self
		await animation_player.animation_finished
		projectiles.add_child(new_thorn)
		new_thorn.global_position = thorn_spawn_point.global_position
		thorns_throwed += 1
		
		print("thorns_throwed: ", thorns_throwed)
	
	print("thorns_throw finished")
	animation_player.play("idle")
	next_move_cd.start()

func saliva_spit():
	next_attack_enabled = false
	is_attacking = true
	next_move_cd.set_wait_time(.5)
	animation_player.play("saliva_spit")
	
	const SALIVA_SCENE = preload("uid://xbt8v7pvtll6")
	var new_saliva: SalivaProjectile = SALIVA_SCENE.instantiate()
	new_saliva.global_position = saliva_spawn_point.global_position
	new_saliva.parent = self
	await animation_player.animation_finished
	projectiles.add_child(new_saliva)
	new_saliva.LaunchProjectile(saliva_spawn_point.global_position, Vector2(-1, 1), 200, 15)
	
	animation_player.play("idle")
	next_move_cd.start()

func basic_block():
	next_attack_enabled = false
	is_blocking = true
	next_move_cd.set_wait_time(.2)
	animation_player.play("basic_block")
	$Hurtbox/CollisionShape2D.debug_color = Color(0xbd77006b)
	
	await get_tree().create_timer(.8).timeout
	is_blocking = false
	$Hurtbox/CollisionShape2D.debug_color = Color(0x00a6186b)
	
	await animation_player.animation_finished
	animation_player.play("idle")
	next_move_cd.start()

func thornmail():
	next_attack_enabled = false
	next_move_cd.set_wait_time(.2)
	animation_player.play("thornmail")
	
	await get_tree().create_timer(.2).timeout
	has_thornmail = true
	$Hurtbox/CollisionShape2D.debug_color = Color(0xf700796b)
	
	await animation_player.animation_finished
	has_thornmail = false
	animation_player.play("idle")
	next_move_cd.start()
	$Hurtbox/CollisionShape2D.debug_color = Color(0x00a6186b)

func take_damage(damage: int):
	if is_blocking or has_thornmail:
		$SFX/sfx_block.play()
		print("nopal was blocking")
		return
	current_health -= damage
	print("nopal was hitted")
	print("nopal health: ", current_health)
	if current_health <= 0:
		animation_player.play("defeat")
		is_dead = true
		emit_signal("nopal_defeated")
	hit_flash(1)
	await get_tree().create_timer(.4).timeout
	hit_flash(0)
	pass

func hit_flash(hit_effect):
	sprite_2d.material.set_shader_parameter("hit_effect", hit_effect)

func _on_next_move_cd_timeout() -> void:
	next_attack_enabled = true
