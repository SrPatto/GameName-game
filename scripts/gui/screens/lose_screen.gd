class_name LoseScreen
extends Control

@onready var back_menu_button: Button = %backMenuButton
@onready var restart_button: Button = %restartButton


func _on_back_menu_button_pressed() -> void:
	get_tree().paused = false
	if !Global.scene_manager:
		return
	Global.scene_manager.change_gui_scene("res://scenes/gui/screens/main_menu_screen.tscn")
	Global.scene_manager.current_2d_scene.queue_free()


func _on_restart_button_pressed() -> void:
	if !Global.scene_manager:
		return
	Global.scene_manager.change_2d_scene("res://scenes/debug.tscn")
	Global.scene_manager.change_gui_scene("res://scenes/gui/screens/pause_screen.tscn")
