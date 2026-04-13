class_name Damaged_State
extends State

func enter() -> void:
	state_label.text = "damaged"
	animations.play(animation_name)
	parent.hit_effect(1)
	input_manager.disabled = true
	parent.stunTimer = 0.4

func exit() -> void:
	parent.damaged = false
	input_manager.disabled = false
	parent.hit_effect(0)
	parent.enable_invulnerability()
	pass

func process_input(event: InputEvent) -> State:
	
	return null

func process_frame(delta: float) -> State:
	if is_dead():
		return defeated_State
	
	if parent.stunTimer > 0.0:
		parent.stunTimer -= delta
		if parent.stunTimer <= 0.0:
			return idle_State 
	
	return null

func process_physics(delta: float) -> State:
	
	return null

func is_dead() -> bool:
	if parent.current_health <= 0:
		parent.is_dead = true
		parent.emit_signal("player_died")
		return true
	return false
