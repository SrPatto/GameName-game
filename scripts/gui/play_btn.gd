extends Button

func _on_pressed() -> void:
	Global.scene_manager.change_2d_scene("res://scenes/debug.tscn")
	Global.scene_manager.change_gui_scene("res://scenes/gui/screens/pause_screen.tscn")
