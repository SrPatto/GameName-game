extends Control
class_name TransitionController

@export var background: ColorRect
@export var animation_player: AnimationPlayer

func transition(animation: String, seconds: float):
	animation_player.play(animation, -1.0, 1/seconds)
