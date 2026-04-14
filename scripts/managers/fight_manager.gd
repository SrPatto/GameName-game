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

func get_time_score() -> int:
	return 2 if time <= 90.0 else 1

func get_health_score() -> int:
	return int((float(player.current_health) / player.max_health) * 10)

func get_final_score(win_screen: WinScreen):
	if !Global.scene_manager:
		return 
	var health_score = get_health_score()
	print("get_health_score: ", health_score)
	var time_score = get_time_score()
	print("get_time_score: x", time_score)
	var final_score = health_score * time_score
	print("final_score: ", final_score)
	
	win_screen.set_time_score(time)
	win_screen.set_health_score(health_score, player.current_health, player.max_health)
	win_screen.set_final_score(final_score)

func defeat():
	disable_game()
	if !Global.scene_manager:
		return
	Global.scene_manager.change_gui_scene("res://scenes/gui/screens/lose_screen.tscn", true, false, false)
	
	print("player loses")
