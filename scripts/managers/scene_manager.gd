extends Node

class_name SceneManager

@export var world_2d: Node2D
@export var gui: Control
@export var transition_controller: TransitionController

var current_2d_scene

var previous_gui_scene
var current_gui_scene


func _ready() -> void:
	Global.scene_manager = self
	# current_2d_scene = $world_2d/Debug
	current_gui_scene = $gui/MainMenu
	# var initial_gui = load().instantiate()
	# gui.add_child(initial_gui)
	# change_gui_scene("res://scenes/gui/screens/main_menu_screen.tscn")


func change_gui_scene(
		new_scene: String,
		delete: bool = true,
		keep_running: bool = false,
		transition: bool = true,
		transition_in: String = "Fade in",
		transition_out: String = "Fade out",
		seconds: float = 0.5,
):
	if transition:
		transition_controller.transition(transition_out, seconds)
		await transition_controller.animation_player.animation_finished
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free() # Removes node entirely
		elif keep_running:
			previous_gui_scene = current_gui_scene
			current_gui_scene.visible = false # Keeps in memory and running
		else:
			gui.remove_child(current_gui_scene) # Keeps in memory, does not run
	var new = load(new_scene).instantiate()
	gui.add_child(new)
	current_gui_scene = new
	if transition:
		transition_controller.transition(transition_in, seconds)


func change_2d_scene(
		new_scene: String,
		delete: bool = true,
		keep_running: bool = false,
		transition: bool = true,
		transition_in: String = "Fade in",
		transition_out: String = "Fade out",
		seconds: float = 1.0,
):
	if transition:
		transition_controller.transition(transition_out, seconds)
		await transition_controller.animation_player.animation_finished
	if current_2d_scene != null:
		if delete:
			current_2d_scene.queue_free() # Removes node entirely
		elif keep_running:
			current_2d_scene.visible = false # Keeps in memory and running
		else:
			world_2d.remove_child(current_2d_scene) # Keeps in memory, does not run
	var new = load(new_scene).instantiate()
	world_2d.add_child(new)
	current_2d_scene = new
	if transition:
		transition_controller.transition(transition_in, seconds)
