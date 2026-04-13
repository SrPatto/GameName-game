class_name State
extends Node

@export_category("States")
@export var idle_State: State
@export var attack_State: State
@export var block_State: State
@export var damaged_State: State
@export var defeated_State: State

@export
var animation_name: String

var state_label: Label

var animations: AnimationPlayer
var input_manager: InputManager
var parent: Player

func enter() -> void:
	animations.play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
