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
