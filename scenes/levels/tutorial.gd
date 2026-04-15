extends Node2D

@export var cooldown_override: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("Enemy").cd_override = cooldown_override


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
