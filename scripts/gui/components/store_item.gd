class_name Store_Item
extends Control

signal item_bought

@onready var icon_texture: TextureRect = %iconTexture
@onready var name_label: Label = %nameLabel
@onready var description_text_label: RichTextLabel = %descriptionTextLabel
@onready var cost_label: Label = %costLabel
@onready var buy_button: Button = %buyButton
@onready var sold_label: Label = %soldLabel


@export var item: Item

@export var bonus_type: int

func _ready() -> void:
	if !item:
		return
	set_item_cost()
	set_item_icon()
	set_item_description()
	set_item_name()
	
	
	if !Global.upgrades_manager:
		return
	buy_button.disabled = Global.upgrades_manager.total_points < item.cost

func set_item_icon():
	icon_texture.texture = item.icon

func set_item_name():
	name_label.text = item.name

func set_item_description():
	description_text_label.text = item.desciption

func set_item_cost():
	cost_label.text = str(item.cost)

func handle_bonus():
	if !Global.upgrades_manager:
		return
	
	match bonus_type:
		0: Global.upgrades_manager.shears_lvl += 1
		1: Global.upgrades_manager.machete_lvl += 1
		2: Global.upgrades_manager.sickle_lvl += 1
		3: Global.upgrades_manager.extraHealth += 1
	
	Global.upgrades_manager.total_points -= item.cost

func _on_buy_button_pressed() -> void:
	handle_bonus()
	emit_signal("item_bought")
	
