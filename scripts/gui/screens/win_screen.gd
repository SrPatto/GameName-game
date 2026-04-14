class_name WinScreen
extends Control

@onready var time_score_label: Label = %time_scoreLabel
@onready var health_score_label: Label = %health_scoreLabel
@onready var final_score_score_label: Label = %finalScore_scoreLabel
@onready var final_score_style_label: Label = %FinalScoreStyleLabel

@onready var back_menu_button: Button = %backMenuButton
@onready var shop_button: Button = %shopButton

func set_health_score(score: int ,current_health: int, max_health: int):
	health_score_label.text = ("%d/%d" % [current_health, max_health])
	if score >= 5:
		health_score_label.set("theme_override_colors/font_color", Color(0.925, 0.718, 0.388, 1.0))

func set_time_score(time: float):
	var minutes = int(time/ 60)
	var seconds = time - minutes * 60
	time_score_label.text = ("%02d:%02d" % [minutes,seconds])
	
	if time <= 90.0:
		time_score_label.set("theme_override_colors/font_color", Color(0.925, 0.718, 0.388, 1.0))

func set_final_score(final_score: int):
	final_score_score_label.text = ("%02d" % final_score)
	if final_score >= 16:
		final_score_style_label.text = "S"
		final_score_style_label.set("theme_override_colors/font_color", Color(0.925, 0.718, 0.388, 1.0))
	elif final_score >= 12 && final_score < 16:
		final_score_style_label.text = "A"
		final_score_style_label.set("theme_override_colors/font_color", Color(0.925, 0.718, 0.388, 1.0))
	elif final_score >= 8 && final_score < 12: 
		final_score_style_label.text = "B"
	elif final_score >= 4 && final_score < 8:
		final_score_style_label.text = "C"
	else:
		final_score_style_label.text = "D"

func _on_back_menu_button_pressed() -> void:
	pass # Replace with function body.


func _on_shop_button_pressed() -> void:
	pass # Replace with function body.
