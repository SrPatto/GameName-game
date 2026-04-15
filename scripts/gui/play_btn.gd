extends Button

func _on_pressed() -> void:
	Global.scene_manager.change_gui_scene("res://scenes/gui/screens/story/story_screen.tscn")
