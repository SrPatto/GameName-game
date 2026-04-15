extends Control

func _on_menu_button_pressed() -> void:
	Global.scene_manager.change_gui_scene("res://scenes/gui/screens/main_menu_screen.tscn")


func _on_h_slider_value_changed(value: float) -> void:
	Global.music_manager.volume_db = linear_to_db(value)
