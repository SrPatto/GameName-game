class_name PlayerHUD
extends Control

@onready var carousel_container: CarouselContainer = %CarouselContainer
@onready var health_container: HBoxContainer = %HealthContainer

var default_weapon: WeaponSlot
var current_index: WeaponSlot

var heart_list : Array[TextureRect]

func _ready() -> void:
	default_weapon = $WeaponsContainer/CarouselContainer/CarouselControl/WeaponSlot
	current_index = carousel_container.position_offset_node.get_child(carousel_container.selected_index)
	
	for child in health_container.get_children():
		heart_list.append(child)

func _process(delta: float) -> void:
	current_index = carousel_container.position_offset_node.get_child(carousel_container.selected_index)

func add_weapon(weapon: Weapon):
	const WEAPON_SLOT_SCENE = preload("uid://5n3stsoiw2ae")
	var new_weapon_slot: WeaponSlot = WEAPON_SLOT_SCENE.instantiate()
	new_weapon_slot.weapon = weapon
	%CarouselControl.add_child(new_weapon_slot)

func update_heart(health: int):
	for i in range(heart_list.size()):
		heart_list[i].visible = i < health
		
