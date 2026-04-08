class_name Player
extends Node2D


@onready var block_area: BlockBox = $block_area
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = $Hitbox
@onready var collision_shape_block: CollisionShape2D = %CollisionShape_block
@onready var collision_shape_hurtbox: CollisionShape2D = %CollisionShape_hurtbox
@onready var collision_shape_hitbox: CollisionShape2D = %CollisionShape_hitbox
@onready var parry_timer: Timer = %ParryTimer
@onready var attack_cd: Timer = %AttackCD
@onready var block_cd: Timer = %BlockCD

@export_category("Combat")
@export_range(3, 5, 1) var max_health: int = 3

@export_category("Managers")
@export var input_manager: InputManager

var current_health := 0

var is_blocking := false
var is_parrying := false

var is_parry_activated := false
var has_parried := false

func _ready() -> void:
	hurtbox.parent = self
	hitbox.parent = self
	block_area.parent = self
	
	current_health = max_health
	print("current_health: ", current_health)
	print("max_health: ", max_health)
	pass

func _process(delta: float) -> void:
	if input_manager.pressed_attack():
		if !attack_cd.is_stopped():
			return
		if is_blocking:
			collision_shape_block.disabled = true
		collision_shape_hitbox.disabled = false
		await get_tree().create_timer(.1).timeout
		collision_shape_hitbox.disabled = true
		attack_cd.start()
	
	if input_manager.pressed_block():
		if !block_cd.is_stopped():
			return
		collision_shape_block.disabled = false
		is_blocking = true
		if !is_parry_activated:
			parry_timer.start()
			is_parry_activated = true
			is_parrying = true
			collision_shape_block.debug_color = Color(1.0, 1.0, 0.282, 0.41)
		if parry_timer.is_stopped():
			is_parrying = false
			collision_shape_block.debug_color = Color(0.0, 0.6, 0.7, 0.41)
		
	if input_manager.realesed_block():
		collision_shape_block.disabled = true
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

func take_damage(damage: int):
	current_health -= damage
	is_parrying = false
	print("current_health: ", current_health)
	print("max_health: ", max_health)
	pass
