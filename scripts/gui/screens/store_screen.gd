class_name StoreScreen
extends Control

@onready var points_label: Label = %pointsLabel
@onready var items_container: HBoxContainer = %itemsContainer
@onready var back_menu_button: Button = %backMenuButton
@onready var next_button: Button = %nextButton

const STORE_ITEM_SCENE = preload("uid://c8d3oghn8ys8w")


func _ready() -> void:
	refresh_store()


func refresh_store():
	for item in items_container.get_children():
		item.queue_free()
	set_total_points_label()
	first_item()
	second_item()
	third_item()
	fourth_item()


func set_total_points_label():
	if !Global.upgrades_manager:
		return
	points_label.text = ("TOTAL POINTS: %d" % Global.upgrades_manager.total_points)


func first_item():
	if !Global.upgrades_manager:
		return
	var next_item_lvl = Global.upgrades_manager.shears_lvl + 1

	var new_item: Store_Item = STORE_ITEM_SCENE.instantiate()
	new_item.bonus_type = 0

	if next_item_lvl < 3:
		match next_item_lvl:
			2:
				new_item.item = preload("uid://dsfw7wy4kybh5")
			3:
				new_item.item = preload("uid://bofa8klvyd7pj")
	else:
		new_item.item = preload("uid://bofa8klvyd7pj")

	items_container.add_child(new_item)
	new_item.connect("item_bought", refresh_store)
	var max_cant: bool = next_item_lvl > 3
	var can_buy: bool = Global.upgrades_manager.total_points > new_item.item.cost

	new_item.buy_button.disabled = (max_cant or !can_buy)
	new_item.sold_label.visible = next_item_lvl > 3


func second_item():
	if !Global.upgrades_manager:
		return
	var next_item_lvl = Global.upgrades_manager.machete_lvl + 1

	var new_item: Store_Item = STORE_ITEM_SCENE.instantiate()
	new_item.bonus_type = 1

	if next_item_lvl < 3:
		match next_item_lvl:
			1:
				new_item.item = preload("uid://c3f03w8x21knw")
			2:
				new_item.item = preload("uid://cj76mebs0rq0w")
			3:
				new_item.item = preload("uid://d4jp50ixs8r1h")
	else:
		new_item.item = preload("uid://d4jp50ixs8r1h")

	items_container.add_child(new_item)
	new_item.connect("item_bought", refresh_store)
	var max_cant: bool = next_item_lvl > 3
	var can_buy: bool = Global.upgrades_manager.total_points > new_item.item.cost

	new_item.buy_button.disabled = (max_cant or !can_buy)
	new_item.sold_label.visible = next_item_lvl > 3


func third_item():
	if !Global.upgrades_manager:
		return
	var next_item_lvl = Global.upgrades_manager.sickle_lvl + 1

	var new_item: Store_Item = STORE_ITEM_SCENE.instantiate()
	new_item.bonus_type = 2

	if next_item_lvl < 3:
		match next_item_lvl:
			1:
				new_item.item = preload("uid://djbdv7m0nko8l")
			2:
				new_item.item = preload("uid://c4l2mxosx3blf")
			3:
				new_item.item = preload("uid://5625sa3o35xk")
	else:
		new_item.item = preload("uid://5625sa3o35xk")

	items_container.add_child(new_item)
	new_item.connect("item_bought", refresh_store)
	var max_cant: bool = next_item_lvl > 3
	var can_buy: bool = Global.upgrades_manager.total_points > new_item.item.cost

	new_item.buy_button.disabled = (max_cant or !can_buy)
	new_item.sold_label.visible = next_item_lvl > 3


func fourth_item():
	if !Global.upgrades_manager:
		return

	var new_item: Store_Item = STORE_ITEM_SCENE.instantiate()
	new_item.bonus_type = 3
	new_item.item = preload("uid://df2iwc6v6w8ys")

	var extraHealth = Global.upgrades_manager.extraHealth

	items_container.add_child(new_item)
	new_item.connect("item_bought", refresh_store)

	var max_cant: bool = extraHealth > 1
	var can_buy: bool = Global.upgrades_manager.total_points > new_item.item.cost

	new_item.buy_button.disabled = (max_cant or !can_buy)
	new_item.sold_label.visible = extraHealth > 1


func _on_back_menu_button_pressed() -> void:
	Global.scene_manager.change_gui_scene("res://scenes/gui/screens/main_menu_screen.tscn")


func _on_next_button_pressed() -> void:
	match Global.current_level:
		0:
			Global.scene_manager.change_gui_scene("res://scenes/gui/screens/story/story_screen.tscn")
			# Global.scene_manager.change_2d_scene("res://scenes/levels/level2.tscn")
		1:
			# Global.scene_manager.current_2d_scene.queue_free()
			Global.scene_manager.change_gui_scene("res://scenes/gui/screens/story/story_screen.tscn")
			# Global.scene_manager.change_2d_scene("res://scenes/levels/level3.tscn")
		2:
			Global.scene_manager.change_gui_scene("res://scenes/gui/screens/story/story_screen.tscn")
			# Global.scene_manager.change_2d_scene("res://scenes/levels/level4.tscn")
		3:
			Global.scene_manager.change_gui_scene("res://scenes/gui/screens/story/story_screen.tscn")
			# Global.scene_manager.change_2d_scene("res://scenes/levels/level5.tscn")
		4:
			Global.scene_manager.change_gui_scene("res://scenes/gui/screens/story/story_screen.tscn")
	Global.current_level += 1
