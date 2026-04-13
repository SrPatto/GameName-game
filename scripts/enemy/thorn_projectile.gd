class_name ThornProjectile
extends Node2D

@onready var hitbox: Hitbox = $Hitbox

@export var speed: float = 200
@export var parent: Node2D

func _ready() -> void:
	hitbox.parent = parent 

func _physics_process(delta: float) -> void:
	global_position += Vector2(0, 1).rotated(1) * speed * delta
	pass

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.parent is not Player:
		return 
	queue_free()


func _on_timer_timeout():
	queue_free()
