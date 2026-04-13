class_name Idle_State
extends State

func enter() -> void:
	state_label.text = "IDLE"
	animations.play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	if input_manager.pressed_attack():
		return attack_State
	if input_manager.pressed_block():
		return block_State
	return null

func process_frame(delta: float) -> State:
	if parent.damaged:
		return damaged_State
	return null

func process_physics(delta: float) -> State:
	
	return null
