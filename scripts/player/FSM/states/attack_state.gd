class_name Attack_State
extends State

var animationEnded := false

func enter() -> void:
	state_label.text = "attack"
	animations.play(animation_name)
	
	animationEnded = false

func exit() -> void:
	parent.attack_cd.start()
	pass

func process_input(event: InputEvent) -> State:
	if input_manager.pressed_attack():
		return attack_State
	if input_manager.pressed_block():
		return block_State
	return null

func process_frame(delta: float) -> State:
	if animationEnded:
		return idle_State
	
	if parent.damaged:
		return damaged_State
	return null

func process_physics(delta: float) -> State:
	
	return null


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animation_name:
		animationEnded = true
