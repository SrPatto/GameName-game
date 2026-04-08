class_name Enemy
extends Node2D

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = $Hitbox
@onready var projectiles: Node2D = $Projectiles
@onready var tuna_spawn_point: Marker2D = %tuna_spawnPoint
@onready var next_move_cd: Timer = %NextMoveCD
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export_category("Combat")
@export var max_health: int = 100
@export_category("List of moves")
@export var list_of_attacks = {
	"basic_attack": false, 
	"strong_attack": false, 
	"tuna_throw": false, 
	"thorn_throw": false, 
	"saliva_spit": false,
	"basic_block": false,
	"thornmail": false }
@export var amount_of_attacks := 3

var available_attacks: Array[String]
var next_attacks: Array[String]

var current_health := 0

var is_attacking := false

func _ready() -> void:
	current_health = max_health
	hurtbox.parent = self
	hitbox.parent = self
	available_attacks = get_available_moves()
	print("list of available attacks: ", available_attacks)
	next_attacks = get_next_attacks(amount_of_attacks)
	print("list of next attacks: ", next_attacks)

func _process(delta: float) -> void:
	if !is_attacking && next_move_cd.is_stopped():
		make_next_attack()

func change_attack(new_attack: String):
	match  new_attack:
		"basic_attack":
			basic_attack()
		"strong_attack":
			strong_attack()
		"tuna_throw":
			tuna_throw()

func make_next_attack():
	var current_attack
	
	if !next_attacks.is_empty():
		current_attack = next_attacks.pop_front()
		change_attack(current_attack)
		print("current attack: ", current_attack)
		print("list of next attacks: ", next_attacks)
	else:
		print("list of available attacks: ", available_attacks)
		next_attacks = get_next_attacks(amount_of_attacks)
		print("list of next attacks: ", next_attacks)
		next_move_cd.set_wait_time(5)
		next_move_cd.start()
		is_attacking = false

func get_available_moves() -> Array[String]:
	var avail_attacks: Array[String]
	
	for attack in list_of_attacks:
		if list_of_attacks[attack]:
			print("attack available: ", attack)
			avail_attacks.append(attack)
	return avail_attacks

func get_next_attacks(lenght: int) -> Array[String]:
	var next_atcks: Array[String]
	
	while (next_atcks.size() < lenght):
		next_atcks.append(available_attacks.pick_random()) 
	
	return next_atcks

func basic_attack():
	is_attacking = true
	next_move_cd.set_wait_time(.5)
	hitbox.collision_shape.disabled = false
	hitbox.damage = 1
	animation_player.play("basic_attack")
	await animation_player.animation_finished
	next_move_cd.start()

func strong_attack():
	is_attacking = true
	next_move_cd.set_wait_time(1.2)
	hitbox.collision_shape.disabled = false
	hitbox.damage = 2
	animation_player.play("basic_attack")
	print("hola")
	await animation_player.animation_finished
	print("adios")

func tuna_throw():
	is_attacking = true
	next_move_cd.set_wait_time(.5)
	
	const TUNA_SCENE = preload("uid://cbfeo6ssxk6c2")
	var new_tuna: TunaProjectile = TUNA_SCENE.instantiate()
	new_tuna.global_position = tuna_spawn_point.global_position
	new_tuna.parent = self
	projectiles.add_child(new_tuna)
	new_tuna.LaunchProjectile(tuna_spawn_point.global_position, Vector2(-1, 1), 300, 45)
	
	next_move_cd.start()

func thorn_throw():
	pass

func _on_next_move_cd_timeout() -> void:
	is_attacking = false
