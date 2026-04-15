class_name TutorialManager
extends Node

@export var enemy: Enemy
@export var player: Player
@export var camera: Camera2D

@export var RANDOM_SHAKE_STRENGTH: float = 30.0
@export var SHAKE_DECAY_RATE: float = 5.0

@onready var rand = RandomNumberGenerator.new()
var shake_strength: float = 0.0

enum Tutorial_State {
	one, 
	two,
	three
}
var current_state: Tutorial_State = Tutorial_State.one

func _ready() -> void:
	init_game_components()
	change_state(Tutorial_State.one)

func change_state(new_state: Tutorial_State):
	current_state = new_state
	match current_state:
		Tutorial_State.one:
			%PanelContainer_1.visible = true
			start_fight()
		Tutorial_State.two:
			%PanelContainer_2.visible = true
			enemy.can_move = false
			pass
		Tutorial_State.three:
			%PanelContainer_3.visible = true
			start_fight()

func init_game_components():
	player.input_manager.disabled = true
	enemy.can_move = false
	player.connect("player_damaged", apply_shake)

func start_fight():
	player.input_manager.disabled = false
	enemy.can_move = true

func disable_game():
	player.input_manager.disabled = true
	enemy.can_move = false

func apply_shake(strength) -> void:
	shake_strength = strength

func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength),
		rand.randf_range(-shake_strength, shake_strength)
	)


func _on_button_1_pressed() -> void:
	%PanelContainer_1.visible = false
	change_state(Tutorial_State.two)

func _on_button_2_pressed() -> void:
	%PanelContainer_2.visible = false
	change_state(Tutorial_State.three)

func _on_button_3_pressed() -> void:
	pass # Replace with function body.
