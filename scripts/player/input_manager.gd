class_name InputManager
extends Node

@export var disabled := false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				%CarouselContainer._next()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				%CarouselContainer._previous()

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
