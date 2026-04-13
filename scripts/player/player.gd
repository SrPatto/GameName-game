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
@onready var invulnerability_timer = %InvulnerabilityTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine = $StateMachine

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
var stunTimer := 0.4
var invulnerability := false

var is_blocking := false
var is_parrying := false
var is_parry_activated := false
var has_parried := false

func _ready() -> void:
	hurtbox.parent = self
	hitbox.parent = self
	block_area.parent = self
	state_machine.init(self, animation_player, input_manager)
	
	change_weapon(hud.current_index.weapon)
	current_health = max_health
	pass

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	if hud.current_index.weapon != current_weapon:
		change_weapon(hud.current_index.weapon)

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
	

func enable_invulnerability():
	blink_effect(1)
	hurtbox.set_collision_mask_value(2, false)
	invulnerability_timer.start()

func disable_invulnerability():
	blink_effect(0)
	hurtbox.set_collision_mask_value(2, true)

func hit_effect(hit_effect, shake_intensity = 1):
	sprite_2d.material.set_shader_parameter("hit_effect", hit_effect)
	sprite_2d.material.set_shader_parameter("shake_intensity", shake_intensity)
func blink_effect(blink_effect):
	sprite_2d.material.set_shader_parameter("blink_effect", blink_effect)


func _on_invulnerability_timer_timeout():
	disable_invulnerability()
