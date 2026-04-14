class_name Fight_Manager
extends Node

@export var enemy: Enemy
@export var player: Player

var time := 0.0

var start_timer := false

func _ready() -> void:
	if !player:
		return
	if !enemy:
		return
	init_game_components()
	start_fight()

func _process(delta: float) -> void:
	if start_timer:
		time += delta

func init_game_components():
	start_timer = false
	player.input_manager.disabled = true
	enemy.can_move = false
	player.connect("player_died", defeat)
	enemy.connect("nopal_defeated", win)

func start_fight():
	start_timer = true
	player.input_manager.disabled = false
	enemy.can_move = true

func disable_game():
	start_timer = false
	player.input_manager.disabled = true
	enemy.can_move = false

func win():
	disable_game()
	if !Global.scene_manager:
		return
	Global.scene_manager.change_gui_scene("res://scenes/gui/screens/win_screen.tscn", true, false, false)
	if Global.scene_manager.current_gui_scene is WinScreen:
		var win_screen: WinScreen = Global.scene_manager.current_gui_scene
		get_final_score(win_screen)
	print("player wins")

func get_time_score(win_screen: WinScreen) -> int:
	if !Global.scene_manager:
		return 1
	var minutes = int(time/ 60)
	var seconds = time - minutes * 60
	win_screen.time_score_label.text = ("%02d:%02d" % [minutes,seconds])
	if time <= 90.0:
		win_screen.time_score_label.set("theme_override_colors/font_color", Color(0.925, 0.718, 0.388, 1.0))
		return 2
	else:
		win_screen.time_score_label.set("theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
		return 1

func get_health_score(win_screen: WinScreen) -> int:
	if !Global.scene_manager:
		return 0
	var score = (float(player.current_health) / player.max_health) * 10
	win_screen.health_score_label.text = ("%d/%d" % [player.current_health,player.max_health])
	if score >= 5:
		win_screen.health_score_label.set("theme_override_colors/font_color", Color(0.925, 0.718, 0.388, 1.0))
	return score

func get_final_score(win_screen: WinScreen):
	if !Global.scene_manager:
		return 
	var health_score = get_health_score(win_screen)
	print("get_health_score: ", health_score)
	var time_score = get_time_score(win_screen)
	print("get_time_score: x", time_score)
	var final_score = health_score * time_score
	print("final_score: ", final_score)
	
	win_screen.final_score_score_label.text = ("%02d" % final_score)
	if final_score >= 16:
		win_screen.final_score_style_label.text = "S"
		win_screen.final_score_style_label.set("theme_override_colors/font_color", Color(0.925, 0.718, 0.388, 1.0))
	elif final_score >= 12 && final_score < 16:
		win_screen.final_score_style_label.text = "A"
		win_screen.final_score_style_label.set("theme_override_colors/font_color", Color(0.925, 0.718, 0.388, 1.0))
	elif final_score >= 8 && final_score < 12: 
		win_screen.final_score_style_label.text = "B"
	elif final_score >= 4 && final_score < 8:
		win_screen.final_score_style_label.text = "C"
	else:
		win_screen.final_score_style_label.text = "D"

func defeat():
	disable_game()
	
		
	print("player loses")
