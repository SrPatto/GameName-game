class_name Weapon
extends Resource

@export var name: String
@export var damage: float
@export var parry_multiplayer: float = 1
@export var cadence: float = 1.0
@export_range(1, 3, 1) var level: int
@export var icon: Texture2D
@export var animation: Texture2D
