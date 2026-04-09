class_name Hitbox
extends Area2D

@export var damage: int
@export var collision_shape: CollisionShape2D

var parent: Node2D

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if parent == null:
		return
	if area == parent:
		return
	if area.parent is Enemy:
		var enemy: Enemy = area.parent
		if !enemy.has_thornmail:
			return
		if parent.has_method("take_damage"):
			parent.take_damage(1) 
