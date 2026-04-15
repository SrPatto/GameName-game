extends Button

func _on_pressed() -> void:
	Global.scene_manager.change_2d_scene("res://scenes/levels/level1.tscn")
	Global.scene_manager.change_gui_scene("res://scenes/gui/screens/pause_screen.tscn")
