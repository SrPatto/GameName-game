class_name Defeated_State
extends State

func enter() -> void:
	state_label.text = "defeated"
	animations.play(animation_name)
	input_manager.disabled = true
	parent.disable_invulnerability()

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	
	return null

func process_frame(delta: float) -> State:
	
	return null

func process_physics(delta: float) -> State:
	
	return null
