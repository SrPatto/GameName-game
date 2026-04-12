class_name WeaponSlot
extends Panel

@export var weapon: Weapon

func _ready() -> void:
	if !weapon:
		return
	%Icon.texture = weapon.icon
