class_name Player
extends Node2D

signal player_died

@onready var block_area: BlockBox = $block_area
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = $Hitbox
@onready var collision_shape_block: CollisionShape2D = %CollisionShape_block
@onready var collision_shape_hurtbox: CollisionShape2D = %CollisionShape_hurtbox
@onready var collision_shape_hitbox: CollisionShape2D = %CollisionShape_hitbox
@onready var parry_timer: Timer = %ParryTimer
@onready var attack_cd: Timer = %AttackCD
@onready var block_cd: Timer = %BlockCD
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

enum Player_State {
	Idle,
	Attack,
	Block,
	Damage,
	Defeated,
	Switching
}
@export var current_state: Player_State = Player_State.Idle

@export_category("Combat")
@export_range(3, 5, 1) var max_health: int = 3
@export var current_weapon: Weapon

@export_category("Managers")
@export var input_manager: InputManager
@export var carousel_container: CarouselContainer
@export var hud: Control

var current_health := 0
var is_dead := false

var damaged := false
var stunTimer := 0.5
var invulnerability := false

var is_blocking := false
var is_parrying := false
var is_parry_activated := false
var has_parried := false

func _ready() -> void:
	hurtbox.parent = self
	hitbox.parent = self
	block_area.parent = self
	
	change_weapon(hud.current_index.weapon)
	current_health = max_health
	animation_player.play("idle")
	pass

func _process(delta: float) -> void:
	if input_manager.pressed_attack():
		if !attack_cd.is_stopped():
			return
		change_state(Player_State.Attack)
		await animation_player.animation_finished
		change_state(Player_State.Idle)
		attack_cd.start()
	
	if input_manager.pressed_block():
		if !block_cd.is_stopped():
			return
		change_state(Player_State.Block)
		
		var current_anim_pos = animation_player.get_current_animation_position()
		if (current_anim_pos >= .4 && current_anim_pos <= 0.5) && !is_parry_activated:
			parry_timer.start()
			is_parry_activated = true
			is_parrying = true
			collision_shape_block.debug_color = Color(1.0, 1.0, 0.282, 0.41)
		if parry_timer.is_stopped():
			is_parrying = false
			collision_shape_block.debug_color = Color(0.0, 0.6, 0.7, 0.41)
		
	if input_manager.realesed_block() and current_state == Player_State.Block:
		animation_player.play("block_out")
		is_blocking = false
		if !has_parried:
			block_cd.start()
		else:
			has_parried = false
		if is_parry_activated:
			is_parry_activated = false
			is_parrying = false
			parry_timer.stop()
			collision_shape_block.debug_color = Color(0.0, 0.6, 0.7, 0.41)
		await animation_player.animation_finished
		change_state(Player_State.Idle)
	
	if hud.current_index.weapon != current_weapon:
		change_weapon(hud.current_index.weapon)

func change_state(new_state: Player_State):
	if current_state == new_state:
		return
	
	current_state = new_state
	
	match current_state:
		Player_State.Idle:
			animation_player.play("idle")
			pass
		Player_State.Attack:
			animation_player.play("attack")
			if is_blocking:
				collision_shape_block.disabled = true
			pass
		Player_State.Block:
			animation_player.play("block_in")
			is_blocking = true
			pass
		Player_State.Damage:
			pass
		Player_State.Defeated:
			pass
		Player_State.Switching:
			pass
	
	print(current_state)


func change_weapon(new_weapon: Weapon):
	animation_player.play("switch")
	current_weapon = new_weapon
	print(current_weapon.name)
	sprite_2d.texture = current_weapon.animation
	hitbox.damage = current_weapon.damage
	await animation_player.animation_finished
	animation_player.play("idle")

func take_damage(damage: int):
	current_health -= damage
	is_parrying = false
	damaged = true
	print("current_health: ", current_health)
	print("max_health: ", max_health)
	if current_health <= 0:
		is_dead = true
		input_manager.disabled = true
		emit_signal("player_died")
		animation_player.play("defeated")
		return
	animation_player.play("damage")
