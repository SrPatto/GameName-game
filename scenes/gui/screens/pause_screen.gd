extends Control

var enemy


func _ready() -> void:
	hide()
	$VBoxContainer2/HSlider.value = db_to_linear(Global.music_manager.volume_db)
	enemy = Global.scene_manager.current_2d_scene.get_node("Enemy")


func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_settings_btn_pressed() -> void:
	if !Global.scene_manager:
		return
	Global.scene_manager.change_gui_scene("res://scenes/gui/screens/settings_menu_screen.tscn")


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	if !Global.scene_manager:
		return
	Global.scene_manager.change_gui_scene("res://scenes/gui/screens/main_menu_screen.tscn")
	Global.scene_manager.current_2d_scene.queue_free()


func _on_continue_btn_pressed() -> void:
	get_tree().paused = false
	get_parent().get_node("SettingsMenu").hide()


func _input(event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = false
		get_parent().get_node("SettingsMenu").hide()


func _on_h_slider_value_changed(value: float) -> void:
	Global.music_manager.volume_db = linear_to_db(value)


func _on_h_slider_2_value_changed(value: float) -> void:
	var stream_players = enemy.get_node("SFX").get_children()
	for stream in stream_players:
		stream.volume_db = linear_to_db(value)
