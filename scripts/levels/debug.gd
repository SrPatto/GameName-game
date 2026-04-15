extends Node2D

var guiNode

@export var cooldown_override: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guiNode = get_parent().get_parent().get_node("gui")
	get_node("Enemy").cd_override = cooldown_override


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("pause"):
			get_tree().paused = true
			guiNode.get_node("SettingsMenu").show()


func _on_left_pressed() -> void:
	$CarouselContainer._previous()


func _on_right_pressed() -> void:
	$CarouselContainer._next()
