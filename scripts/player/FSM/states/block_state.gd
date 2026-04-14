class_name Block_State
extends State

@onready var hurtbox = $"../../Hurtbox"
@onready var collision_shape_block: CollisionShape2D = %CollisionShape_block
@onready var sprite_2d = $"../../Sprite2D"

@onready var parry_timer: Timer = %ParryTimer
@onready var block_cd: Timer = %BlockCD

var is_parry_activated := false

func enter() -> void:
	state_label.text = "block"
	animations.play(animation_name)
	
	hurtbox.set_collision_mask_value(2, false)
	is_parry_activated = false
	parent.is_blocking = true

func exit() -> void:
	hurtbox.set_collision_mask_value(2, true)
	sprite_2d.material.set_shader_parameter("outline_color", Color(0.0, 0.0, 0.0, 0.0))
	animations.play("block_out")
	parent.is_blocking = false
	if !parent.has_parried:
		block_cd.start()
	else:
		parent.has_parried = false
	if is_parry_activated:
		is_parry_activated = false
		parent.is_parrying = false
		parry_timer.stop()
		collision_shape_block.debug_color = Color(0.0, 0.6, 0.7, 0.41)
	collision_shape_block.disabled = true
	pass

func process_input(event: InputEvent) -> State:
	if input_manager.realesed_block():
		return idle_State
		
	if parent.damaged:
		return damaged_State
	if parent.is_dead:
		return defeated_State
	return null

func process_frame(delta: float) -> State:
	var current_anim_pos = animations.get_current_animation_position()
	if (current_anim_pos >= .4 && current_anim_pos <= 0.5) && !is_parry_activated:
		parry()
	
	return null

func process_physics(delta: float) -> State:
	
	return null

func parry():
	parry_timer.start()
	is_parry_activated = true
	parent.is_parrying = true
	sprite_2d.material.set_shader_parameter("outline_color", Color(1.0, 1.0, 0.282, 1.0))
	collision_shape_block.debug_color = Color(1.0, 1.0, 0.282, 0.41)

func _on_parry_timer_timeout():
	parent.is_parrying = false
	sprite_2d.material.set_shader_parameter("outline_color", Color(0.0, 0.6, 0.7, 1.0))
	collision_shape_block.debug_color = Color(0.0, 0.6, 0.7, 0.41)
	
