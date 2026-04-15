extends Control

var labels = []
@export_file("*.ttf") var font_file
@export var write_speed = 1.1
@export var line_interval = 2.5
@export var start_pos = 0.0
@export var end_pos = 1.0
var Story0: Array[String]
var Story1: Array[String]
var Story2: Array[String]
var Story3: Array[String]
var Story4: Array[String]
var Story5: Array[String]
var Story6: Array[String]
var Story7: Array[String]
@export_range(0, 7) var active_story: int


func set_stories():
	Story1.append("I tried telling dad about Nopalus")
	Story1.append("He refused to take a look, work is really stressing him out")
	Story1.append("The news have been talking about some mysterious")
	Story1.append("substance that affects plants' growth")
	Story1.append("They said nothing about weird looking plants appearing to try to kill somebody")
	Story1.append("I think Nopalus is learning some of my defensive moves...")

	Story2.append("I swear I defeated Nopalus yesterday")
	Story2.append("At least it looked like it, I heard him crying all night")
	Story2.append("I could feel sad for him")
	Story2.append("If only he hadn't throw a BIG ASS prickly pear to my window")
	Story2.append("He literally asked me to kick his spiky ass today")

	Story3.append("Nopalus is still here")
	Story3.append("I know I suck at fighting, not gonna lie")
	Story3.append("But Nopalus will be a tough oponent to anyone who dares to face him anyway")
	Story3.append("Dad looks worried every time he leaves for work")
	Story3.append("He said it's ok for me to use some of his tools (guess he knows I've been using them)")

	Story4.append("I didn't expect Nopalus to keep learning new attacks")
	Story4.append("I'm starting to feel really tired")
	Story4.append("Once you think you won he is back the next day")
	Story4.append("Is this guy invincible?")
	Story4.append("It really feels like every time I fight him he just gets stronger")
	Story4.append("Wait")
	Story4.append("Then I must become STRONGER")

	Story5.append("I hate Nopalus")
	Story5.append("He shows a clear satisfaction everytime I appear to fight him")
	Story5.append("That bastard know I can't kill him")
	Story5.append("Even I can't get rid of him, I noticed he stopped growing with every tiny victory I had")
	Story5.append("So")
	Story5.append("This thing has definitely an end...")
	Story5.append("It does right?")

	Story6.append("This sucks")
	Story6.append("I guess this is the only thing left for me")
	Story6.append("fight Nopalus forever")
	Story6.append("As I was opening the garden door someone stopped me")
	Story6.append("You won't need to worry about that anymore")
	Story6.append("you did really well")
	Story6.append("let me handle it")

	Story7.append("Thank you")
	Story7.append("for playing")
	Story7.append("Nopalus")

	Story0.append("A giant monster plant has appeared")
	Story0.append("I may be the less qualified person to take care of it")
	Story0.append("I asked dad, who's a gardener")
	Story0.append("He says he's busy")
	Story0.append("I really don't want to fight that")
	Story0.append("the thing is")
	Story0.append("This plant enjoys to fight")


func _ready():
	$nextButton.hide()
	active_story = Global.current_level
	set_stories()
	var selected_story: Array[String]
	match active_story:
		0:
			selected_story = Story0
		1:
			selected_story = Story1
		2:
			selected_story = Story2
		3:
			selected_story = Story3
		4:
			selected_story = Story4
		5:
			selected_story = Story5
		6:
			selected_story = Story6
		7:
			selected_story = Story7
	for line in selected_story:
		var label = Label.new()
		label.text = line
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		$titleLabel.text = str("DAY ", Global.current_level)
		$LinesContainer.add_child(label)
		var settings = LabelSettings.new()
		var font = load(font_file)
		settings.font = font
		settings.font_size = 30
		settings.shadow_color = Color(0, 0, 0, 0.6)
		settings.shadow_offset = Vector2(3, 3)
		settings.shadow_size = 10
		settings.paragraph_spacing = 30
		label.label_settings = settings
		labels.append(label)
		labels.append(label)


func _process(delta):
	for i in labels.size():
		labels[i].modulate.a = start_pos
		var tween = create_tween()
		tween.tween_interval(i * line_interval)
		tween.tween_property(labels[i], "modulate:a", end_pos, write_speed)


func _on_next_button_pressed() -> void:
	match Global.current_level:
		0:
			Global.scene_manager.change_2d_scene("res://scenes/levels/tutorial.tscn")
			# Global.scene_manager.current_gui_scene.queue_free()
			Global.scene_manager.change_gui_scene("res://scenes/gui/screens/pause_screen.tscn")
		1:
			Global.scene_manager.change_2d_scene("res://scenes/levels/level1.tscn")
			Global.scene_manager.change_gui_scene("res://scenes/gui/screens/pause_screen.tscn")
		2:
			Global.scene_manager.change_2d_scene("res://scenes/levels/level2.tscn")
			Global.scene_manager.change_gui_scene("res://scenes/gui/screens/pause_screen.tscn")
		3:
			Global.scene_manager.change_2d_scene("res://scenes/levels/level3.tscn")
			Global.scene_manager.change_gui_scene("res://scenes/gui/screens/pause_screen.tscn")
		4:
			Global.scene_manager.change_2d_scene("res://scenes/levels/level4.tscn")
			Global.scene_manager.change_gui_scene("res://scenes/gui/screens/pause_screen.tscn")
		5:
			Global.scene_manager.change_2d_scene("res://scenes/levels/level5.tscn")
			Global.scene_manager.change_gui_scene("res://scenes/gui/screens/pause_screen.tscn")
		6:
			Global.scene_manager.change_gui_scene("res://scenes/gui/screens/story/story_screen.tscn")
			Global.current_level += 1
		7:
			Global.scene_manager.change_gui_scene("res://scenes/gui/screens/main_menu_screen.tscn")
			Global.current_level = 1
		8:
			Global.scene_manager.change_gui_scene("res://scenes/gui/screens/main_menu_screen.tscn")
			Global.current_level = 1


func _on_back_menu_button_pressed() -> void:
	Global.scene_manager.change_gui_scene("res://scenes/gui/screens/main_menu_screen.tscn")


func _on_skip_btn_pressed() -> void:
	line_interval = 0
	$nextButton.show()


func _on_timer_timeout() -> void:
	$nextButton.show()
