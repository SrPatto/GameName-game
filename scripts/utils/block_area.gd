class_name BlockBox
extends Area2D

var parent: Node2D

var parry_damage: float = 1.0
var parry_multiplayer: float = 1.0

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if parent == null:
		return
	if area is not Hitbox:
		return
	if area.parent == parent:
		return
	var hitbox: Hitbox = area
	if hitbox.parent is Enemy:
		hitbox.collision_shape.set_disabled.call_deferred(true)
		if parent is not Player:
			return
		if !parent.is_parrying:
			return
		if hitbox.parent.has_method("take_damage"):
			hitbox.parent.take_damage(parry_damage * parry_multiplayer)
		parent.has_parried = true
		parent.block_cd.stop()
		print("perfect parry")
