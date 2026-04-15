class_name PlayerHUD
extends Control

@onready var carousel_container: CarouselContainer = %CarouselContainer

var default_weapon: WeaponSlot
var current_index: WeaponSlot

func _ready() -> void:
	default_weapon = $WeaponsContainer/CarouselContainer/CarouselControl/WeaponSlot
	current_index = carousel_container.position_offset_node.get_child(carousel_container.selected_index)

func _process(delta: float) -> void:
	current_index = carousel_container.position_offset_node.get_child(carousel_container.selected_index)

func add_weapon(weapon: Weapon):
	const WEAPON_SLOT_SCENE = preload("uid://5n3stsoiw2ae")
	var new_weapon_slot: WeaponSlot = WEAPON_SLOT_SCENE.instantiate()
	new_weapon_slot.weapon = weapon
	%CarouselControl.add_child(new_weapon_slot)
