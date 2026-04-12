extends Control

@onready var carousel_container: CarouselContainer = %CarouselContainer

var current_index: WeaponSlot

func _ready() -> void:
	current_index = carousel_container.position_offset_node.get_child(carousel_container.selected_index)

func _process(delta: float) -> void:
	current_index = carousel_container.position_offset_node.get_child(carousel_container.selected_index)
