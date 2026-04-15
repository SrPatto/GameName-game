extends Control

var labels = []
@export var title = "NOPALUS"
@export var grow_speed = 0.3
@export var letter_interval = 0.58
@export var start_pos = 300
@export var end_pos = 200
@export_file("*.ttf") var font_file


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for letter in title:
		var label = Label.new()
		label.text = letter
		var font = load(font_file)
		$TitleContainer.add_child(label)
		var settings = LabelSettings.new()
		settings.font = font
		settings.font_size = 240
		settings.shadow_color = Color(0, 0, 0, 0.6)
		settings.shadow_offset = Vector2(3, 3)
		settings.shadow_size = 30
		label.label_settings = settings
		labels.append(label)


func _process(delta: float) -> void:
	for i in labels.size():
		labels[i].position.y = start_pos
		var tween = create_tween()
		tween.tween_interval(i * letter_interval)
		tween.tween_property(labels[i], "position:y", end_pos, grow_speed)


func _on_settings_btn_pressed() -> void:
	Global.scene_manager.change_gui_scene("res://scenes/gui/screens/settings_menu_screen.tscn")
