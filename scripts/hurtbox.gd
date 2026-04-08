class_name Hurtbox
extends Area2D

var parent: Node2D

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
	if parent.has_method("take_damage"):
		parent.take_damage(hitbox.damage)
		hitbox.collision_shape.set_disabled.call_deferred(true)
