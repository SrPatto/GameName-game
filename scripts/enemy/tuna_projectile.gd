class_name TunaProjectile
extends Node2D

@onready var hitbox: Hitbox = $Tuna_sprite/Hitbox

@export var parent: Node2D

var initial_speed: float
var throw_angle_degrees: float
const gravity := 9.8
var time: float = 0.0

var initial_position: Vector2
var throw_direction: Vector2

var z_axis := 0.0
var is_launch: bool = false

var time_mult := 6.0

var rotate_angle := 0.0

func _ready() -> void:
	hitbox.parent = parent
	pass

func _process(delta: float) -> void:
	time += delta * time_mult
	
	if is_launch:
		z_axis = initial_speed * sin(deg_to_rad(throw_angle_degrees)) * time - 0.5 * gravity * pow(time, 2)
		
		if z_axis > 0: 
			var x_axis: float = initial_speed * cos(deg_to_rad(throw_angle_degrees)) * time
			global_position = initial_position + throw_direction * x_axis
			
			rotate_angle = delta * -time_mult
			
			$Tuna_sprite.position.y = -z_axis
			$Tuna_sprite.rotate(rotate_angle)
			

func LaunchProjectile(initial_pos: Vector2, dir: Vector2, desired_distance: float, desired_angle_deg: float):
	initial_position = initial_pos
	throw_direction = dir.normalized()
	
	throw_angle_degrees = desired_angle_deg
	
	initial_speed = pow(desired_distance * gravity / sin(2 * deg_to_rad(desired_angle_deg)), 0.5)
	
	global_position = initial_pos
	time = 0.0
	
	z_axis = 0
	is_launch = true


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.parent is not Player:
		return 
	var destroy_frame := 1
	$Tuna_sprite.frame = destroy_frame
	await get_tree().create_timer(.5).timeout
	queue_free()
