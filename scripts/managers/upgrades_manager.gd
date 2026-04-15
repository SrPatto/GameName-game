class_name UpgradesManager
extends Node

@export_category("Weapons")
@export var shears_lvl = 1
@export var machete_lvl = 0
@export var sickle_lvl = 0
@export_category("Health")
@export var extraHealth = 0
@export_category("Points")
@export var total_points := 0


func _ready() -> void:
	Global.upgrades_manager = self


func get_shears_resource() -> Weapon:
	match shears_lvl:
		1:
			return preload("uid://mk0gacb6w275")
		2:
			return preload("uid://b347siaw816i1")
		3:
			return preload("uid://bqqt7m2vp848s")

	return preload("uid://mk0gacb6w275")


func get_machete_resource() -> Weapon:
	match machete_lvl:
		1:
			return preload("uid://csrfct3swvv5f")
		2:
			return preload("uid://dhxyq24el1h1d")
		3:
			return preload("uid://b2n4knipwgy38")

	return null


func get_sickle_resource() -> Weapon:
	match sickle_lvl:
		1:
			return preload("uid://dphvfnytd8nnk")
		2:
			return preload("uid://bk4aiomrqfsxt")
		3:
			return preload("uid://cmaiq2b2jlds8")

	return null
