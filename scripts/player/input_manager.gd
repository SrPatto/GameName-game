class_name InputManager
extends Node

@export var disabled := false

func pressed_attack() -> bool:
	if disabled:
		return false
	return Input.is_action_just_pressed("attack")

func pressed_skill() -> bool:
	if disabled:
		return false
	return Input.is_action_just_pressed("skill")

func pressed_block() -> bool:
	if disabled:
		return false
	return Input.is_action_pressed("block")
func realesed_block() -> bool:
	if disabled:
		return false
	return Input.is_action_just_released("block")
